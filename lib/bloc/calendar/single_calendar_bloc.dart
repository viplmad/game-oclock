import 'dart:async';
import 'dart:collection';

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
      yield const CalendarNotLoaded('Connection lost. Trying to reconnect');

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch (e) {

        yield CalendarNotLoaded(e.toString());

      }
    }

  }

  Stream<SingleCalendarState> _mapLoadToState() async* {

    yield CalendarLoading();

    try {

      final List<TimeLog> timeLogs = await getReadAllTimeLogsStream().first;
      final List<DateTime> finishDates = await getReadAllFinishDatesStream().first;

      final Set<DateTime> logDates = timeLogs.fold(SplayTreeSet<DateTime>(), (Set<DateTime> previousDates, TimeLog log) => previousDates..add(log.dateTime));

      DateTime selectedDate = DateTime.now();
      List<TimeLog> selectedTimeLogs = <TimeLog>[];
      if(logDates.isNotEmpty) {
        selectedDate = logDates.last;

        selectedTimeLogs = timeLogs
            .where((TimeLog log) => log.dateTime.isSameDate(selectedDate))
            .toList(growable: false)..sort();
      }

      final bool isSelectedDateFinish = finishDates.any((DateTime date) => date.isSameDate(selectedDate));

      final int selectedTotalTimeSeconds = selectedTimeLogs.fold(0, (int previousSeconds, TimeLog log) => previousSeconds + log.time.inSeconds);
      final Duration selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);

      yield CalendarLoaded(
        timeLogs,
        logDates,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
      );

    } catch (e) {

      yield CalendarNotLoaded(e.toString());

    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDateToState(UpdateSelectedDate event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final CalendarStyle style = (state as CalendarLoaded).style;
      final DateTime previousSelectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      Duration selectedTotalTime = (state as CalendarLoaded).selectedTotalTime;

      if((style == CalendarStyle.List) || (style == CalendarStyle.Graph && !event.date.isInWeekOf(previousSelectedDate))) {
        selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, event.date, style);

        final int selectedTotalTimeSeconds = selectedTimeLogs.fold(0, (int previousSeconds, TimeLog log) => previousSeconds + log.time.inSeconds);
        selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);
      }

      final bool isSelectedDateFinish = finishDates.any((DateTime date) => date.isSameDate(event.date));

      yield CalendarLoaded(
        timeLogs,
        logDates,
        finishDates,
        event.date,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        style,
      );
    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDateFirstToState(UpdateSelectedDateFirst event) async* {

    if(state is CalendarLoaded) {
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        final DateTime firstDate = logDates.first;

        add(UpdateSelectedDate(firstDate));
      }
    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDateLastToState(UpdateSelectedDateLast event) async* {

    if(state is CalendarLoaded) {
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        final DateTime lastDate = logDates.last;

        add(UpdateSelectedDate(lastDate));
      }
    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDatePreviousToState(UpdateSelectedDatePrevious event) async* {

    if(state is CalendarLoaded) {
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;

      DateTime? previousDate;
      if(logDates.isNotEmpty) {
        final List<DateTime> listLogDates = logDates.toList(growable: false);
        int selectedIndex = listLogDates.indexWhere((DateTime date) => date.isSameDate(selectedDate));
        selectedIndex = (selectedIndex.isNegative)? listLogDates.length : selectedIndex;

        for(int index = selectedIndex - 1; index >= 0 && previousDate == null; index--) {
          final DateTime date = listLogDates.elementAt(index);

          if(date.isBefore(selectedDate)) {
            previousDate = date;
          }
        }
      }

      add(UpdateSelectedDate(previousDate?? selectedDate));
    }

  }

  Stream<SingleCalendarState> _mapUpdateSelectedDateNextToState(UpdateSelectedDateNext event) async* {

    if(state is CalendarLoaded) {
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;

      DateTime? nextDate;
      if(logDates.isNotEmpty) {
        final List<DateTime> listLogDates = logDates.toList(growable: false);
        int selectedIndex = listLogDates.indexWhere((DateTime date) => date.isSameDate(selectedDate));
        selectedIndex = (selectedIndex.isNegative)? 0 : selectedIndex;

        for(int index = selectedIndex + 1; index < listLogDates.length && nextDate == null; index++) {
          final DateTime date = listLogDates.elementAt(index);

          if(date.isAfter(selectedDate)) {
            nextDate = date;
          }
        }
      }

      add(UpdateSelectedDate(nextDate?? selectedDate));
    }

  }

  Stream<SingleCalendarState> _mapUpdateStyleToState(UpdateStyle event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;

      final int rotatingIndex = ((state as CalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      final List<TimeLog> selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, selectedDate, updatedStyle);

      final int selectedTotalTimeSeconds = selectedTimeLogs.fold(0, (int previousSeconds, TimeLog log) => previousSeconds + log.time.inSeconds);
      final Duration selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);

      yield CalendarLoaded(
        timeLogs,
        logDates,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        updatedStyle,
      );
    }

  }

  Stream<SingleCalendarState> _mapUpdateToState(UpdateCalendar event) async* {

    yield CalendarLoaded(
      event.timeLogs,
      event.logDates,
      event.finishDates,
      event.selectedDate,
      event.selectedTimeLogs,
      event.isSelectedDateFinish,
      event.selectedTotalTime,
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
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;
      Duration selectedTotalTime = (state as CalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as CalendarLoaded).style;

      if(timeLogs.isEmpty) {
        selectedDate = managerState.otherItem.dateTime;
      }

      final List<TimeLog> updatedTimeLogs = List<TimeLog>.from(timeLogs)..add(managerState.otherItem);
      final Set<DateTime> updatedLogDates = SplayTreeSet<DateTime>.from(logDates)..add(managerState.otherItem.dateTime);

      if((style == CalendarStyle.List && managerState.otherItem.dateTime.isSameDate(selectedDate))
          || (style == CalendarStyle.Graph && managerState.otherItem.dateTime.isInWeekOf(selectedDate))) {
        selectedTimeLogs = List<TimeLog>.from(selectedTimeLogs)..add(managerState.otherItem);
        selectedTimeLogs..sort();

        final int selectedTotalTimeSeconds = selectedTimeLogs.fold(0, (int previousSeconds, TimeLog log) => previousSeconds + log.time.inSeconds);
        selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);
      }

      add(UpdateCalendar(
        updatedTimeLogs,
        updatedLogDates,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        style,
      ));
    }

  }

  void _mapDeletedTimeLogToEvent(RelationDeleted<TimeLog> managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;
      Duration selectedTotalTime = (state as CalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<TimeLog> updatedTimeLogs = timeLogs
          .where((TimeLog log) => log.dateTime != managerState.otherItem.dateTime)
          .toList(growable: false);

      if(!updatedTimeLogs.any((TimeLog log) => log.dateTime.isSameDate(managerState.otherItem.dateTime))) {
        logDates.removeWhere((DateTime date) => date.isSameDate(managerState.otherItem.dateTime));
      }

      if(updatedTimeLogs.isEmpty) {
        selectedDate = DateTime.now();
      }

      if(managerState.otherItem.dateTime.isInWeekOf(selectedDate)) {
        selectedTimeLogs = selectedTimeLogs
            .where((TimeLog log) => log.dateTime != managerState.otherItem.dateTime)
            .toList(growable: false);

        selectedTotalTime = Duration(seconds: selectedTotalTime.inSeconds - managerState.otherItem.time.inSeconds);
      }

      add(UpdateCalendar(
        updatedTimeLogs,
        logDates,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        style,
      ));
    }

  }

  void _mapAddedFinishDateToEvent(RelationAdded<DateTime> managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;
      final Duration selectedTotalTime = (state as CalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<DateTime> updatedFinishDates = List<DateTime>.from(finishDates)..add(managerState.otherItem);

      isSelectedDateFinish = isSelectedDateFinish || managerState.otherItem.isSameDate(selectedDate);

      add(UpdateCalendar(
        timeLogs,
        logDates,
        updatedFinishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        style,
      ));
    }

  }

  void _mapDeletedFinishDateToEvent(RelationDeleted<DateTime> managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      bool isSelectedDateFinish = (state as CalendarLoaded).isSelectedDateFinish;
      final Duration selectedTotalTime = (state as CalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<DateTime> updatedFinishDates = finishDates
          .where((DateTime date) => !date.isSameDate(managerState.otherItem))
          .toList(growable: false);

      isSelectedDateFinish = !(isSelectedDateFinish && managerState.otherItem.isSameDate(selectedDate));

      add(UpdateCalendar(
        timeLogs,
        logDates,
        updatedFinishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
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
        final DateTime mondayOfSelectedDate = selectedDate.getMondayOfWeek();

        final Duration dayDuration = const Duration(days: 1);
        DateTime dateOfWeek = mondayOfSelectedDate;
        for(int index = 0; index < 7; index++) {
          final Iterable<TimeLog> dayTimeLogs = timeLogs.where((TimeLog log) => log.dateTime.isSameDate(dateOfWeek));

          if(dayTimeLogs.isNotEmpty) {
            selectedTimeLogs.addAll(dayTimeLogs);
          } else {
            selectedTimeLogs.add(
              TimeLog(dateTime: dateOfWeek, time: const Duration()),
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