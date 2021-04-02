import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'single_calendar.dart';


class SingleCalendarBloc extends Bloc<SingleCalendarEvent, SingleCalendarState> {
  SingleCalendarBloc({
    required this.itemId,
    required this.iCollectionRepository,
    required this.timeLogManagerBloc,
    required this.finishDateManagerBloc,
  }) : super(CalendarLoading()) {

    timeLogManagerSubscription = timeLogManagerBloc.stream.listen(mapTimeLogManagerStateToEvent);
    finishDateManagerSubscription = finishDateManagerBloc.stream.listen(mapFinishDateManagerStateToEvent);

  }

  final int itemId;
  final ICollectionRepository iCollectionRepository;
  final GameTimeLogRelationManagerBloc timeLogManagerBloc;
  final GameFinishDateRelationManagerBloc finishDateManagerBloc;
  late StreamSubscription<RelationManagerState> timeLogManagerSubscription;
  late StreamSubscription<RelationManagerState> finishDateManagerSubscription;

  @override
  Stream<SingleCalendarState> mapEventToState(SingleCalendarEvent event) async* {

    yield* _checkConnection();

    if(event is LoadCalendar) {

      yield* _mapLoadToState();

    } else if(event is UpdateSelectedDate) {

      yield* _mapUpdateSelectedDateToState(event);

    } else if(event is UpdateStyle) {

      yield* _mapUpdateStyleToState(event);

    } else if(event is UpdateSelectedDateFirst) {

      yield* _mapUpdateSelectedDateFirstToState(event);

    } else if(event is UpdateSelectedDateLast) {

      yield* _mapUpdateSelectedDateLastToState(event);

    } else if(event is UpdateSelectedDatePrevious) {

      yield* _mapUpdateSelectedDatePreviousToState(event);

    } else if(event is UpdateSelectedDateNext) {

      yield* _mapUpdateSelectedDateNextToState(event);

    } else if(event is UpdateCalendar) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<SingleCalendarState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield CalendarNotLoaded('Connection lost. Trying to reconnect');

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<SingleCalendarState> _mapLoadToState() async* {

    yield CalendarLoading();

    try {

      List<TimeLog> timeLogs = await getReadAllTimeLogsStream().first;
      final List<DateTime> finishDates = await getReadAllFinishDatesStream().first;

      DateTime selectedDate = DateTime.now();
      List<TimeLog> selectedTimeLogs = <TimeLog>[];
      if(timeLogs.isNotEmpty) {
        timeLogs..sort();
        selectedDate = timeLogs.last.dateTime;
        selectedTimeLogs = timeLogs
            .where((TimeLog log) => log.dateTime.isSameDate(selectedDate))
            .toList(growable: false);
      }

      bool isSelectedDateFinish = finishDates.any((DateTime date) => date.isSameDate(selectedDate));

      yield CalendarLoaded(
        timeLogs,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
      );

    } catch (e) {

      yield CalendarNotLoaded(e.toString());

    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDateToState(UpdateSelectedDate event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final CalendarStyle style = (state as CalendarLoaded).style;
      final DateTime previousSelectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;

      if((style == CalendarStyle.List) || (style == CalendarStyle.Graph && !event.date.isInWeekOf(previousSelectedDate))) {
        selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, event.date, style);
      }

      bool isSelectedDateFinish = finishDates.any((DateTime date) => date.isSameDate(event.date));

      yield CalendarLoaded(
        timeLogs,
        finishDates,
        event.date,
        selectedTimeLogs,
        isSelectedDateFinish,
        style,
      );
    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDateFirstToState(UpdateSelectedDateFirst event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;

      if(timeLogs.isNotEmpty) {
        DateTime firstDate = timeLogs.first.dateTime;

        add(UpdateSelectedDate(firstDate));
      }
    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDateLastToState(UpdateSelectedDateLast event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;

      if(timeLogs.isNotEmpty) {
        DateTime lastDate = timeLogs.last.dateTime;

        add(UpdateSelectedDate(lastDate));
      }
    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDatePreviousToState(UpdateSelectedDatePrevious event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;

      DateTime? previousDate;
      if(timeLogs.isNotEmpty) {
        int selectedIndex = timeLogs.indexWhere((TimeLog log) => log.dateTime.isSameDate(selectedDate));
        selectedIndex = (selectedIndex.isNegative)? timeLogs.length : selectedIndex;

        for(int index = selectedIndex - 1; index >= 0 && previousDate == null; index --) {
          TimeLog log = timeLogs.elementAt(index);

          if(log.dateTime.isBefore(selectedDate)) {
            previousDate = log.dateTime;
          }
        }
      }

      add(UpdateSelectedDate(previousDate?? selectedDate));
    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDateNextToState(UpdateSelectedDateNext event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;

      DateTime? nextDate;
      if(timeLogs.isNotEmpty) {
        int selectedIndex = timeLogs.indexWhere((TimeLog log) => log.dateTime.isSameDate(selectedDate));
        selectedIndex = (selectedIndex.isNegative)? 0 : selectedIndex;

        for(int index = selectedIndex + 1; index < timeLogs.length && nextDate == null; index ++) {
          TimeLog log = timeLogs.elementAt(index);

          if(log.dateTime.isAfter(selectedDate)) {
            nextDate = log.dateTime;
          }
        }
      }

      add(UpdateSelectedDate(nextDate?? selectedDate));
    }

  }

  Stream<SingleCalendarState> _mapUpdateStyleToState(UpdateStyle event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;

      final rotatingIndex = ((state as CalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      final List<TimeLog> selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, selectedDate, updatedStyle);

      yield CalendarLoaded(
        timeLogs,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        updatedStyle,
      );
    }

  }

  Stream<SingleCalendarState> _mapUpdateToState(UpdateCalendar event) async* {

    yield CalendarLoaded(
      event.timeLogs,
      event.finishDates,
      event.selectedDate,
      event.selectedTimeLogs,
      event.isSelectedDateFinish,
      event.style,
    );

  }

  void mapTimeLogManagerStateToEvent(RelationManagerState managerState) {

    if(managerState is RelationAdded<TimeLog>) {

      _mapAddedTimeLogToEvent(managerState);

    } else if(managerState is RelationDeleted<TimeLog>) {

      _mapDeletedTimeLogToEvent(managerState);

    }

  }

  void mapFinishDateManagerStateToEvent(RelationManagerState managerState) {

    if(managerState is RelationAdded<DateTime>) {

      _mapAddedFinishDateToEvent(managerState);

    } else if(managerState is RelationDeleted<DateTime>) {

      _mapDeletedFinishDateToEvent(managerState);

    }

  }

  void _mapAddedTimeLogToEvent(RelationAdded<TimeLog> managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;
      final CalendarStyle style = (state as CalendarLoaded).style;

      if(timeLogs.isEmpty) {
        selectedDate = managerState.otherItem.dateTime;
      }

      final List<TimeLog> updatedTimeLogs = List.from(timeLogs)..add(managerState.otherItem);

      if((style == CalendarStyle.List && managerState.otherItem.dateTime.isSameDate(selectedDate))
          || (style == CalendarStyle.Graph && managerState.otherItem.dateTime.isInWeekOf(selectedDate))) {
        selectedTimeLogs = List.from(selectedTimeLogs)..add(managerState.otherItem);
        selectedTimeLogs..sort();
      }

      add(UpdateCalendar(
        updatedTimeLogs..sort(),
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        style,
      ));
    }

  }

  void _mapDeletedTimeLogToEvent(RelationDeleted<TimeLog> managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<TimeLog> updatedTimeLogs = timeLogs
          .where((TimeLog log) => log.dateTime != managerState.otherItem.dateTime)
          .toList(growable: false);

      if(updatedTimeLogs.isEmpty) {
        selectedDate = DateTime.now();
      }

      if(managerState.otherItem.dateTime.isInWeekOf(selectedDate)) {
        selectedTimeLogs = selectedTimeLogs
            .where((TimeLog log) => log.dateTime != managerState.otherItem.dateTime)
            .toList(growable: false);
      }

      add(UpdateCalendar(
        updatedTimeLogs,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        style,
      ));
    }

  }

  void _mapAddedFinishDateToEvent(RelationAdded<DateTime> managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<DateTime> updatedFinishDates = List.from(finishDates)..add(managerState.otherItem);

      isSelectedDateFinish = isSelectedDateFinish || managerState.otherItem.isSameDate(selectedDate);

      add(UpdateCalendar(
        timeLogs,
        updatedFinishDates..sort(),
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        style,
      ));
    }

  }

  void _mapDeletedFinishDateToEvent(RelationDeleted<DateTime> managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<DateTime> updatedFinishDates = finishDates
          .where((DateTime date) => !date.isSameDate(managerState.otherItem))
          .toList(growable: false);

      isSelectedDateFinish = !(isSelectedDateFinish && managerState.otherItem.isSameDate(selectedDate));

      add(UpdateCalendar(
        timeLogs,
        updatedFinishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        style,
      ));
    }

  }

  List<TimeLog> _selectedTimeLogsInStyle(List<TimeLog> timeLogs, DateTime selectedDate, CalendarStyle style) {
    List<TimeLog> selectedTimeLogs = <TimeLog>[];

    switch(style) {
      case CalendarStyle.List:
        selectedTimeLogs = timeLogs
            .where((TimeLog log) => log.dateTime.isSameDate(selectedDate))
            .toList(growable: false);
        break;
      case CalendarStyle.Graph:
        DateTime mondayOfSelectedDate = selectedDate.getMondayOfWeek();

        Duration dayDuration = Duration(days: 1);
        DateTime dateOfWeek = mondayOfSelectedDate;
        for(int index = 0; index < 7; index++) {
          Iterable<TimeLog> dayTimeLogs = timeLogs.where((TimeLog log) => log.dateTime.isSameDate(dateOfWeek));

          if(dayTimeLogs.isNotEmpty) {
            selectedTimeLogs.addAll(dayTimeLogs);
          } else {
            selectedTimeLogs.add(
              TimeLog(dateTime: dateOfWeek, time: Duration()),
            );
          }

          dateOfWeek = dateOfWeek.add(dayDuration);
        }
        break;
    }

    return selectedTimeLogs..sort();
  }

  @override
  Future<void> close() {

    timeLogManagerSubscription.cancel();
    finishDateManagerSubscription.cancel();
    return super.close();

  }

  Stream<List<TimeLog>> getReadAllTimeLogsStream() {

    return iCollectionRepository.getTimeLogsFromGame(itemId);

  }

  Stream<List<DateTime>> getReadAllFinishDatesStream() {

    return iCollectionRepository.getFinishDatesFromGame(itemId);

  }
}