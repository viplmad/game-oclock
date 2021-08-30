import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'package:backend/entity/entity.dart' show GameFinishEntity, GameID, GameTimeLogEntity;
import 'package:backend/model/model.dart' show GameFinish, GameTimeLog;
import 'package:backend/mapper/mapper.dart' show GameFinishMapper, GameTimeLogMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameFinishRepository, GameTimeLogRepository;
import 'package:backend/model/calendar_range.dart';
import 'package:backend/model/calendar_style.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'single_calendar.dart';
import 'range_list_utils.dart';


class SingleCalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  SingleCalendarBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required this.timeLogManagerBloc,
    required this.finishDateManagerBloc,
  }) :
    this.id = GameID(itemId),
    this.gameTimeLogRepository = collectionRepository.gameTimeLogRepository,
    this.gameFinishRepository = collectionRepository.gameFinishRepository,
    super(CalendarLoading()) {

      timeLogManagerSubscription = timeLogManagerBloc.stream.listen(mapTimeLogManagerStateToEvent);
      finishDateManagerSubscription = finishDateManagerBloc.stream.listen(mapFinishDateManagerStateToEvent);

    }

  final GameID id;
  final GameTimeLogRepository gameTimeLogRepository;
  final GameFinishRepository gameFinishRepository;
  final GameRelationManagerBloc<GameTimeLog> timeLogManagerBloc;
  final GameRelationManagerBloc<GameFinish> finishDateManagerBloc;
  late final StreamSubscription<ItemRelationManagerState> timeLogManagerSubscription;
  late final StreamSubscription<ItemRelationManagerState> finishDateManagerSubscription;

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {

    yield* _checkConnection();

    if(event is LoadSingleCalendar) {

      yield* _mapLoadToState();

    } else if(event is UpdateSelectedDate) {

      yield* _mapUpdateSelectedDateToState(event);

    } else if(event is UpdateCalendarRange) {

      yield* _mapUpdateRangeToState(event);

    } else if(event is UpdateCalendarStyle) {

      yield* _mapUpdateStyleToState(event);

    } else if(event is UpdateSelectedDateFirst) {

      yield* _mapUpdateSelectedDateFirstToState(event);

    } else if(event is UpdateSelectedDateLast) {

      yield* _mapUpdateSelectedDateLastToState(event);

    } else if(event is UpdateSelectedDatePrevious) {

      yield* _mapUpdateSelectedDatePreviousToState(event);

    } else if(event is UpdateSelectedDateNext) {

      yield* _mapUpdateSelectedDateNextToState(event);

    } else if(event is UpdateSingleCalendar) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<CalendarState> _checkConnection() async* {

    if(gameFinishRepository.isClosed()) {
      yield const CalendarNotLoaded('Connection lost. Trying to reconnect');

      try {

        gameFinishRepository.reconnect();
        await gameFinishRepository.open();

      } catch (e) {

        yield CalendarNotLoaded(e.toString());

      }
    }

  }

  Stream<CalendarState> _mapLoadToState() async* {

    yield CalendarLoading();

    try {

      final List<GameTimeLog> timeLogs = await getReadAllTimeLogsStream();
      final List<GameFinish> finishDates = await getReadAllFinishDatesStream();

      final Set<DateTime> logDates = timeLogs.fold(SplayTreeSet<DateTime>(), (Set<DateTime> previousDates, GameTimeLog log) => previousDates..add(log.dateTime));

      DateTime selectedDate = DateTime.now();
      if(logDates.isNotEmpty) {
        selectedDate = logDates.last;
      }

      final CalendarRange range = CalendarRange.Day;
      final List<GameTimeLog> selectedTimeLogs = _selectedTimeLogsInRange(timeLogs, selectedDate, range);

      final Duration selectedTotalTime = selectedTimeLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameTimeLog log) => previousDuration + log.time);

      final bool isSelectedDateFinish = finishDates.any((GameFinish finish) => finish.dateTime.isSameDay(selectedDate));

      yield SingleCalendarLoaded(
        timeLogs,
        logDates,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        range,
      );

    } catch (e) {

      yield CalendarNotLoaded(e.toString());

    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateToState(UpdateSelectedDate event) async* {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      final DateTime previousSelectedDate = (state as SingleCalendarLoaded).selectedDate;

      List<GameTimeLog> selectedTimeLogs;
      Duration selectedTotalTime;
      if(RangeListUtils.doesNewDateNeedRecalculation(event.date, previousSelectedDate, range)) {
        selectedTimeLogs = _selectedTimeLogsInRange(timeLogs, event.date, range);

        selectedTotalTime = selectedTimeLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameTimeLog log) => previousDuration + log.time);
      } else {
        selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
        selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      }

      final bool isSelectedDateFinish = finishDates.any((GameFinish finish) => finish.dateTime.isSameDay(event.date));

      yield SingleCalendarLoaded(
        timeLogs,
        logDates,
        finishDates,
        event.date,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        range,
        style,
      );
    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateFirstToState(UpdateSelectedDateFirst event) async* {

    if(state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        final DateTime firstDate = logDates.first;

        add(UpdateSelectedDate(firstDate));
      }
    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateLastToState(UpdateSelectedDateLast event) async* {

    if(state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        final DateTime lastDate = logDates.last;

        add(UpdateSelectedDate(lastDate));
      }
    }

  }

  Stream<CalendarState> _mapUpdateSelectedDatePreviousToState(UpdateSelectedDatePrevious event) async* {

    if(state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final DateTime previousDate = RangeListUtils.getPreviousDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(previousDate));
    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateNextToState(UpdateSelectedDateNext event) async* {

    if(state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final DateTime nextDate = RangeListUtils.getNextDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(nextDate));
    }

  }

  Stream<CalendarState> _mapUpdateRangeToState(UpdateCalendarRange event) async* {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      final CalendarRange previousRange = (state as SingleCalendarLoaded).range;

      if(event.range != previousRange) {
        final List<GameTimeLog> selectedTimeLogs = _selectedTimeLogsInRange(timeLogs, selectedDate, event.range);

        final Duration selectedTotalTime = selectedTimeLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameTimeLog log) => previousDuration + log.time);

        yield SingleCalendarLoaded(
          timeLogs,
          logDates,
          finishDates,
          selectedDate,
          selectedTimeLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          event.range,
          style,
        );
      }
    }

  }

  Stream<CalendarState> _mapUpdateStyleToState(UpdateCalendarStyle event) async* {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;
      final Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final int rotatingIndex = ((state as SingleCalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      yield SingleCalendarLoaded(
        timeLogs,
        logDates,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        range,
        updatedStyle,
      );
    }

  }

  Stream<CalendarState> _mapUpdateToState(UpdateSingleCalendar event) async* {

    yield SingleCalendarLoaded(
      event.timeLogs,
      event.logDates,
      event.finishDates,
      event.selectedDate,
      event.selectedTimeLogs,
      event.isSelectedDateFinish,
      event.selectedTotalTime,
      event.range,
      event.style,
    );

  }

  void mapTimeLogManagerStateToEvent(ItemRelationManagerState managerState) {

    if(managerState is ItemRelationAdded<GameTimeLog>) {

      _mapAddedTimeLogToEvent(managerState);

    } else if(managerState is ItemRelationDeleted<GameTimeLog>) {

      _mapDeletedTimeLogToEvent(managerState);

    }

  }

  void mapFinishDateManagerStateToEvent(ItemRelationManagerState managerState) {

    if(managerState is ItemRelationAdded<GameFinish>) {

      _mapAddedFinishDateToEvent(managerState);

    } else if(managerState is ItemRelationDeleted<GameFinish>) {

      _mapDeletedFinishDateToEvent(managerState);

    }

  }

  void _mapAddedTimeLogToEvent(ItemRelationAdded<GameTimeLog> managerState) {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final GameTimeLog addedGameLog = managerState.otherItem;

      if(timeLogs.isEmpty) {
        selectedDate = addedGameLog.dateTime;
      }

      final List<GameTimeLog> updatedTimeLogs = List<GameTimeLog>.from(timeLogs)..add(addedGameLog);
      final Set<DateTime> updatedLogDates = SplayTreeSet<DateTime>.from(logDates)..add(addedGameLog.dateTime);

      Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      if(range == CalendarRange.Day && addedGameLog.dateTime.isSameDay(selectedDate)) {
        selectedTimeLogs = List<GameTimeLog>.from(selectedTimeLogs)..add(addedGameLog);
        selectedTimeLogs..sort();

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if(range == CalendarRange.Week && addedGameLog.dateTime.isInWeekOf(selectedDate)) {
        final int weekIndex = addedGameLog.dateTime.weekday - 1;
        final GameTimeLog dayTimeLog = selectedTimeLogs.elementAt(weekIndex);
        selectedTimeLogs[weekIndex] = GameTimeLog(dateTime: dayTimeLog.dateTime, time: dayTimeLog.time + addedGameLog.time);

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if(range == CalendarRange.Month && addedGameLog.dateTime.isInMonthAndYearOf(selectedDate)) {
        final int monthIndex = addedGameLog.dateTime.day - 1;
        final GameTimeLog dayTimeLog = selectedTimeLogs.elementAt(monthIndex);
        selectedTimeLogs[monthIndex] = GameTimeLog(dateTime: dayTimeLog.dateTime, time: dayTimeLog.time + addedGameLog.time);

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if(range == CalendarRange.Year && addedGameLog.dateTime.isInYearOf(selectedDate)) {
        final int yearIndex = addedGameLog.dateTime.month - 1;
        final GameTimeLog monthTimeLog = selectedTimeLogs.elementAt(yearIndex);
        selectedTimeLogs[yearIndex] = GameTimeLog(dateTime: monthTimeLog.dateTime, time: monthTimeLog.time + addedGameLog.time);

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      }

      add(UpdateSingleCalendar(
        updatedTimeLogs,
        updatedLogDates,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        range,
        style,
      ));
    }

  }

  void _mapDeletedTimeLogToEvent(ItemRelationDeleted<GameTimeLog> managerState) {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final GameTimeLog deletedGameLog = managerState.otherItem;

      final List<GameTimeLog> updatedTimeLogs = timeLogs
          .where((GameTimeLog log) => log.dateTime != deletedGameLog.dateTime)
          .toList(growable: false);

      if(!updatedTimeLogs.any((GameTimeLog log) => log.dateTime.isSameDay(deletedGameLog.dateTime))) {
        logDates.removeWhere((DateTime date) => date.isSameDay(deletedGameLog.dateTime));
      }

      if(updatedTimeLogs.isEmpty) {
        selectedDate = DateTime.now();
      }

      Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      if(range == CalendarRange.Day && deletedGameLog.dateTime.isSameDay(selectedDate)) {
        selectedTimeLogs = selectedTimeLogs
            .where((GameTimeLog log) => !log.dateTime.isSameDay(deletedGameLog.dateTime))
            .toList(growable: false);

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if(range == CalendarRange.Week && deletedGameLog.dateTime.isInWeekOf(selectedDate)) {
        final int weekIndex = deletedGameLog.dateTime.weekday - 1;
        final GameTimeLog dayTimeLog = selectedTimeLogs.elementAt(weekIndex);
        selectedTimeLogs[weekIndex] = GameTimeLog(dateTime: dayTimeLog.dateTime, time: dayTimeLog.time - deletedGameLog.time);

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if(range == CalendarRange.Month && deletedGameLog.dateTime.isInMonthAndYearOf(selectedDate)) {
        final int monthIndex = deletedGameLog.dateTime.day - 1;
        final GameTimeLog dayTimeLog = selectedTimeLogs.elementAt(monthIndex);
        selectedTimeLogs[monthIndex] = GameTimeLog(dateTime: dayTimeLog.dateTime, time: dayTimeLog.time - deletedGameLog.time);

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if(range == CalendarRange.Year && deletedGameLog.dateTime.isInYearOf(selectedDate)) {
        final int yearIndex = deletedGameLog.dateTime.month - 1;
        final GameTimeLog monthTimeLog = selectedTimeLogs.elementAt(yearIndex);
        selectedTimeLogs[yearIndex] = GameTimeLog(dateTime: monthTimeLog.dateTime, time: monthTimeLog.time - deletedGameLog.time);

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      }

      add(UpdateSingleCalendar(
        updatedTimeLogs,
        logDates,
        finishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        range,
        style,
      ));
    }

  }

  void _mapAddedFinishDateToEvent(ItemRelationAdded<GameFinish> managerState) {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      final Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;

      final List<GameFinish> updatedFinishDates = List<GameFinish>.from(finishDates)..add(managerState.otherItem);

      isSelectedDateFinish = isSelectedDateFinish || managerState.otherItem.dateTime.isSameDay(selectedDate);

      add(UpdateSingleCalendar(
        timeLogs,
        logDates,
        updatedFinishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        range,
        style,
      ));
    }

  }

  void _mapDeletedFinishDateToEvent(ItemRelationDeleted<GameFinish> managerState) {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      final Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;

      final List<GameFinish> updatedFinishDates = finishDates
          .where((GameFinish finish) => !finish.dateTime.isSameDay(managerState.otherItem.dateTime))
          .toList(growable: false);

      isSelectedDateFinish = !(isSelectedDateFinish && managerState.otherItem.dateTime.isSameDay(selectedDate));

      add(UpdateSingleCalendar(
        timeLogs,
        logDates,
        updatedFinishDates,
        selectedDate,
        selectedTimeLogs,
        isSelectedDateFinish,
        selectedTotalTime,
        range,
        style,
      ));
    }

  }

  List<GameTimeLog> _selectedTimeLogsInRange(List<GameTimeLog> timeLogs, DateTime selectedDate, CalendarRange range) {
    final List<GameTimeLog> selectedTimeLogs = RangeListUtils.createTimeLogListByRange(timeLogs, selectedDate, range);
    return selectedTimeLogs..sort();
  }

  @override
  Future<void> close() {

    timeLogManagerSubscription.cancel();
    finishDateManagerSubscription.cancel();
    return super.close();

  }

  Future<List<GameTimeLog>> getReadAllTimeLogsStream() {

    final Future<List<GameTimeLogEntity>> entityListFuture = gameTimeLogRepository.findAllFromGame(id);
    return GameTimeLogMapper.futureEntityListToModelList(entityListFuture);

  }

  Future<List<GameFinish>> getReadAllFinishDatesStream() {

    final Future<List<GameFinishEntity>> entityListFuture = gameFinishRepository.findAllFromGame(id);
    return GameFinishMapper.futureEntityListToModelList(entityListFuture);

  }
}