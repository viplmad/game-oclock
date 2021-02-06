import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/model/model.dart';

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
        selectedDate = timeLogs.first.dateTime;
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

      final List<TimeLog> selectedTimeLogs = timeLogs
          .where((TimeLog log) => log.dateTime.isSameDate(event.date))
          .toList(growable: false);

      yield CalendarLoaded(
        timeLogs,
        finishDates,
        event.date,
        selectedTimeLogs,
      );
    }

  }

  Stream<CalendarState> _mapUpdateToState(UpdateCalendar event) async* {

    yield CalendarLoaded(
      event.timeLogs,
      event.finishDates,
      event.selectedDate,
      event.selectedTimeLogs,
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
      ));
    }

  }

  void _mapDeletedTimeLogToEvent(TimeLogDeleted managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      final List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;

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
      ));
    }

  }

  void _mapAddedFinishDateToEvent(FinishDateAdded managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;

      final List<DateTime> updatedFinishDates = List.from(finishDates)..add(managerState.date);

      add(UpdateCalendar(
          timeLogs,
          updatedFinishDates..sort(),
          selectedDate,
          selectedTimeLogs,
      ));
    }

  }

  void _mapDeletedFinishDateToEvent(FinishDateDeleted managerState) {

    if(state is CalendarLoaded) {
      final List<TimeLog> timeLogs = (state as CalendarLoaded).timeLogs;
      List<DateTime> finishDates = (state as CalendarLoaded).finishDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<TimeLog> selectedTimeLogs = (state as CalendarLoaded).selectedTimeLogs;

      final List<DateTime> updatedFinishDates = finishDates
          .where((DateTime date) => date != managerState.date)
          .toList(growable: false);

      add(UpdateCalendar(
          timeLogs,
          updatedFinishDates,
          selectedDate,
          selectedTimeLogs,
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