import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'package:backend/entity/entity.dart' show GameFinishEntity, GameID, GameTimeLogEntity;
import 'package:backend/model/model.dart' show GameFinish, GameTimeLog;
import 'package:backend/mapper/mapper.dart' show GameFinishMapper, GameTimeLogMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameFinishRepository, GameTimeLogRepository;
import 'package:backend/model/calendar_style.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'single_calendar.dart';


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
      List<GameTimeLog> selectedTimeLogs = <GameTimeLog>[];
      if(logDates.isNotEmpty) {
        selectedDate = logDates.last;

        selectedTimeLogs = timeLogs
            .where((GameTimeLog log) => log.dateTime.isSameDate(selectedDate))
            .toList(growable: false)..sort();
      }

      final bool isSelectedDateFinish = finishDates.any((GameFinish finish) => finish.dateTime.isSameDate(selectedDate));

      final int selectedTotalTimeSeconds = selectedTimeLogs.fold(0, (int previousSeconds, GameTimeLog log) => previousSeconds + log.time.inSeconds);
      final Duration selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);

      yield SingleCalendarLoaded(
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

  Stream<CalendarState> _mapUpdateSelectedDateToState(UpdateSelectedDate event) async* {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      final DateTime previousSelectedDate = (state as SingleCalendarLoaded).selectedDate;
      List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;

      if((style == CalendarStyle.List) || (style == CalendarStyle.Graph && !event.date.isInWeekOf(previousSelectedDate))) {
        selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, event.date, style);

        final int selectedTotalTimeSeconds = selectedTimeLogs.fold(0, (int previousSeconds, GameTimeLog log) => previousSeconds + log.time.inSeconds);
        selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);
      }

      final bool isSelectedDateFinish = finishDates.any((GameFinish finish) => finish.dateTime.isSameDate(event.date));

      yield SingleCalendarLoaded(
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

  Stream<CalendarState> _mapUpdateSelectedDateNextToState(UpdateSelectedDateNext event) async* {

    if(state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;

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

  Stream<CalendarState> _mapUpdateStyleToState(UpdateCalendarStyle event) async* {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;

      final int rotatingIndex = ((state as SingleCalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      final List<GameTimeLog> selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, selectedDate, updatedStyle);

      final int selectedTotalTimeSeconds = selectedTimeLogs.fold(0, (int previousSeconds, GameTimeLog log) => previousSeconds + log.time.inSeconds);
      final Duration selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);

      yield SingleCalendarLoaded(
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

  Stream<CalendarState> _mapUpdateToState(UpdateSingleCalendar event) async* {

    yield SingleCalendarLoaded(
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
      Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      if(timeLogs.isEmpty) {
        selectedDate = managerState.otherItem.dateTime;
      }

      final List<GameTimeLog> updatedTimeLogs = List<GameTimeLog>.from(timeLogs)..add(managerState.otherItem);
      final Set<DateTime> updatedLogDates = SplayTreeSet<DateTime>.from(logDates)..add(managerState.otherItem.dateTime);

      if((style == CalendarStyle.List && managerState.otherItem.dateTime.isSameDate(selectedDate))
          || (style == CalendarStyle.Graph && managerState.otherItem.dateTime.isInWeekOf(selectedDate))) {
        selectedTimeLogs = List<GameTimeLog>.from(selectedTimeLogs)..add(managerState.otherItem);
        selectedTimeLogs..sort();

        final int selectedTotalTimeSeconds = selectedTimeLogs.fold(0, (int previousSeconds, GameTimeLog log) => previousSeconds + log.time.inSeconds);
        selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);
      }

      add(UpdateSingleCalendar(
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

  void _mapDeletedTimeLogToEvent(ItemRelationDeleted<GameTimeLog> managerState) {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      final bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;
      Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final List<GameTimeLog> updatedTimeLogs = timeLogs
          .where((GameTimeLog log) => log.dateTime != managerState.otherItem.dateTime)
          .toList(growable: false);

      if(!updatedTimeLogs.any((GameTimeLog log) => log.dateTime.isSameDate(managerState.otherItem.dateTime))) {
        logDates.removeWhere((DateTime date) => date.isSameDate(managerState.otherItem.dateTime));
      }

      if(updatedTimeLogs.isEmpty) {
        selectedDate = DateTime.now();
      }

      if(managerState.otherItem.dateTime.isInWeekOf(selectedDate)) {
        selectedTimeLogs = selectedTimeLogs
            .where((GameTimeLog log) => log.dateTime != managerState.otherItem.dateTime)
            .toList(growable: false);

        selectedTotalTime = Duration(seconds: selectedTotalTime.inSeconds - managerState.otherItem.time.inSeconds);
      }

      add(UpdateSingleCalendar(
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

  void _mapAddedFinishDateToEvent(ItemRelationAdded<GameFinish> managerState) {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;
      final Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final List<GameFinish> updatedFinishDates = List<GameFinish>.from(finishDates)..add(managerState.otherItem);

      isSelectedDateFinish = isSelectedDateFinish || managerState.otherItem.dateTime.isSameDate(selectedDate);

      add(UpdateSingleCalendar(
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

  void _mapDeletedFinishDateToEvent(ItemRelationDeleted<GameFinish> managerState) {

    if(state is SingleCalendarLoaded) {
      final List<GameTimeLog> timeLogs = (state as SingleCalendarLoaded).timeLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<GameFinish> finishDates = (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      final List<GameTimeLog> selectedTimeLogs = (state as SingleCalendarLoaded).selectedTimeLogs;
      bool isSelectedDateFinish = (state as SingleCalendarLoaded).isSelectedDateFinish;
      final Duration selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final List<GameFinish> updatedFinishDates = finishDates
          .where((GameFinish finish) => !finish.dateTime.isSameDate(managerState.otherItem.dateTime))
          .toList(growable: false);

      isSelectedDateFinish = !(isSelectedDateFinish && managerState.otherItem.dateTime.isSameDate(selectedDate));

      add(UpdateSingleCalendar(
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

  List<GameTimeLog> _selectedTimeLogsInStyle(List<GameTimeLog> timeLogs, DateTime selectedDate, CalendarStyle style) {
    List<GameTimeLog> selectedTimeLogs = <GameTimeLog>[];

    switch(style) {
      case CalendarStyle.List:
        selectedTimeLogs = timeLogs
            .where((GameTimeLog log) => log.dateTime.isSameDate(selectedDate))
            .toList(growable: false);
        break;
      case CalendarStyle.Graph:
        final DateTime mondayOfSelectedDate = selectedDate.getMondayOfWeek();

        final Duration dayDuration = const Duration(days: 1);
        DateTime dateOfWeek = mondayOfSelectedDate;
        for(int index = 0; index < 7; index++) {
          final Iterable<GameTimeLog> dayTimeLogs = timeLogs.where((GameTimeLog log) => log.dateTime.isSameDate(dateOfWeek));

          if(dayTimeLogs.isNotEmpty) {
            selectedTimeLogs.addAll(dayTimeLogs);
          } else {
            selectedTimeLogs.add(
              GameTimeLog(dateTime: dateOfWeek, time: const Duration()),
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

  Future<List<GameTimeLog>> getReadAllTimeLogsStream() {

    final Future<List<GameTimeLogEntity>> entityListFuture = gameTimeLogRepository.findAllFromGame(id);
    return GameTimeLogMapper.futureEntityListToModelList(entityListFuture);

  }

  Future<List<GameFinish>> getReadAllFinishDatesStream() {

    final Future<List<GameFinishEntity>> entityListFuture = gameFinishRepository.findAllFromGame(id);
    return GameFinishMapper.futureEntityListToModelList(entityListFuture);

  }
}