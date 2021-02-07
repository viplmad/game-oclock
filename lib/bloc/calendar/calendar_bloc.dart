import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../calendar_manager/calendar_manager.dart';
import 'calendar.dart';


class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    @required this.itemId,
    @required this.iCollectionRepository,
    @required this.managerBloc,
  }) : super(CalendarLoading()) {

    managerSubscription = managerBloc.listen(mapManagerStateToEvent);

  }

  final int itemId;
  final ICollectionRepository iCollectionRepository;
  final CalendarManagerBloc managerBloc;
  StreamSubscription<CalendarManagerState> managerSubscription;

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {

    yield* _checkConnection();

    if(event is LoadCalendar) {

      yield* _mapLoadToState();

    } else if(event is UpdateSelectedDate) {

      yield* _mapUpdateSelectedDateToState(event);

    } else if(event is UpdateStyle) {

      yield* _mapUpdateStyleToState(event);

    } else if(event is UpdateCalendar) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<CalendarState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield CalendarNotLoaded("Connection lost. Trying to reconnect");

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<CalendarState> _mapLoadToState() async* {

    yield CalendarLoading();

    try {

      List<TimeLog> timeLogs = await getReadAllTimeLogsStream().first;
      final List<DateTime> finishDates = await getReadAllFinishDatesStream().first;

      DateTime selectedDate = DateTime.now();
      List<TimeLog> selectedTimeLogs = List<TimeLog>();
      if(timeLogs.isNotEmpty) {
        timeLogs..sort();
        selectedDate = timeLogs.last.dateTime;
        selectedTimeLogs = timeLogs
            .where((TimeLog log) => log.dateTime.isSameDate(selectedDate))
            .toList(growable: false);
      }

      yield CalendarLoaded(
        timeLogs,
        finishDates,
        selectedDate,
        selectedTimeLogs,
      );

    } catch (e) {

      yield CalendarNotLoaded(e.toString());

    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateToState(UpdateSelectedDate event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<TimeLog> selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, event.date, style);

      yield CalendarLoaded(
        timeLogs,
        finishDates,
        event.date,
        selectedTimeLogs,
        style,
      );
    }

  }

  List<TimeLog> _selectedTimeLogsInStyle(List<TimeLog> timeLogs, DateTime selectedDate, CalendarStyle style) {
    List<TimeLog> selectedTimeLogs = List<TimeLog>();

    switch(style) {
      case CalendarStyle.List:
        selectedTimeLogs = timeLogs
            .where((TimeLog log) => log.dateTime.isSameDate(selectedDate))
            .toList(growable: false);
        break;
      case CalendarStyle.Graph:
        DateTime mondayOfSelectedDate;
        if(selectedDate.weekday == 1) {
          mondayOfSelectedDate = selectedDate;
        } else {
          int daysToRemove = selectedDate.weekday - 1;
          mondayOfSelectedDate = selectedDate.subtract(Duration(days: daysToRemove));
        }

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

    return selectedTimeLogs;
  }

  Stream<CalendarState> _mapUpdateStyleToState(UpdateStyle event) async* {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;

      final rotatingIndex = ((state as CalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      final List<TimeLog> selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, selectedDate, updatedStyle);

      yield CalendarLoaded(
        timeLogs,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        updatedStyle,
      );
    }

  }

  Stream<CalendarState> _mapUpdateToState(UpdateCalendar event) async* {

    yield CalendarLoaded(
      event.timeLogs,
      event.finishDates,
      event.selectedDate,
      event.selectedTimeLogs,
      event.style,
    );

  }

  void mapManagerStateToEvent(CalendarManagerState managerState) {

    if(managerState is TimeLogAdded) {

      _mapAddedTimeLogToEvent(managerState);

    } else if(managerState is TimeLogDeleted) {

      _mapDeletedTimeLogToEvent(managerState);

    } else if(managerState is FinishDateAdded) {

      _mapAddedFinishDateToEvent(managerState);

    } else  if(managerState is FinishDateDeleted) {

      _mapDeletedFinishDateToEvent(managerState);

    }

  }

  void _mapAddedTimeLogToEvent(TimeLogAdded managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<TimeLog> updatedTimeLogs = List.from(timeLogs)..add(managerState.log);

      if(managerState.log.dateTime.isSameDate(selectedDate)) {
        selectedTimeLogs = List.from(selectedTimeLogs)..add(managerState.log);
        selectedTimeLogs..sort();
      }

      add(UpdateCalendar(
        updatedTimeLogs..sort(),
        finishDates,
        selectedDate,
        selectedTimeLogs,
        style,
      ));
    }

  }

  void _mapDeletedTimeLogToEvent(TimeLogDeleted managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<TimeLog> updatedTimeLogs = timeLogs
          .where((TimeLog log) => log.dateTime != managerState.log.dateTime)
          .toList(growable: false);

      if(managerState.log.dateTime.isSameDate(selectedDate)) {
        selectedTimeLogs = selectedTimeLogs
            .where((TimeLog log) => log.dateTime != managerState.log.dateTime)
            .toList(growable: false);
      }

      add(UpdateCalendar(
        updatedTimeLogs,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        style,
      ));
    }

  }

  void _mapAddedFinishDateToEvent(FinishDateAdded managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<DateTime> updatedFinishDates = List.from(finishDates)..add(managerState.date);

      add(UpdateCalendar(
        timeLogs,
        updatedFinishDates..sort(),
        selectedDate,
        selectedTimeLogs,
        style,
      ));
    }

  }

  void _mapDeletedFinishDateToEvent(FinishDateDeleted managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;
      final CalendarStyle style = (state as CalendarLoaded).style;

      final List<DateTime> updatedFinishDates = finishDates
          .where((DateTime date) => date != managerState.date)
          .toList(growable: false);

      add(UpdateCalendar(
        timeLogs,
        updatedFinishDates,
        selectedDate,
        selectedTimeLogs,
        style,
      ));
    }

  }

  @override
  Future<void> close() {

    managerSubscription?.cancel();
    return super.close();

  }

  Stream<List<TimeLog>> getReadAllTimeLogsStream() {

    return iCollectionRepository.getTimeLogsFromGame(itemId);

  }

  Stream<List<DateTime>> getReadAllFinishDatesStream() {

    return iCollectionRepository.getFinishDatesFromGame(itemId);

  }
}