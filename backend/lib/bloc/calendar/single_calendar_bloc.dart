import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show GameLogDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, GameLogService, GameFinishService;
import 'package:backend/model/model.dart'
    show CalendarRange, CalendarStyle, ItemFinish;
import 'package:backend/utils/datetime_extension.dart';
import 'package:backend/utils/game_calendar_utils.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'single_calendar.dart';
import 'range_list_utils.dart';

class SingleCalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  SingleCalendarBloc({
    required this.itemId,
    required GameCollectionService collectionService,
    required this.gameLogManagerBloc,
    required this.gameFinishManagerBloc,
  })  : gameLogService = collectionService.gameLogService,
        gameFinishService = collectionService.gameFinishService,
        super(CalendarLoading()) {
    on<LoadSingleCalendar>(_mapLoadToState);
    on<UpdateSelectedDate>(_mapUpdateSelectedDateToState);
    on<UpdateCalendarRange>(_mapUpdateRangeToState);
    on<UpdateCalendarStyle>(_mapUpdateStyleToState);
    on<UpdateSelectedDateFirst>(_mapUpdateSelectedDateFirstToState);
    on<UpdateSelectedDateLast>(_mapUpdateSelectedDateLastToState);
    on<UpdateSelectedDatePrevious>(_mapUpdateSelectedDatePreviousToState);
    on<UpdateSelectedDateNext>(_mapUpdateSelectedDateNextToState);
    on<UpdateSingleCalendar>(_mapUpdateToState);

    gameLogManagerSubscription =
        gameLogManagerBloc.stream.listen(_mapGameLogManagerStateToEvent);
    finishDateManagerSubscription =
        gameFinishManagerBloc.stream.listen(_mapFinishDateManagerStateToEvent);
  }

  final int itemId;
  final GameLogService gameLogService;
  final GameFinishService gameFinishService;
  final GameLogRelationManagerBloc gameLogManagerBloc;
  final GameFinishRelationManagerBloc gameFinishManagerBloc;
  late final StreamSubscription<ItemRelationManagerState>
      gameLogManagerSubscription;
  late final StreamSubscription<ItemRelationManagerState>
      finishDateManagerSubscription;

  void _mapLoadToState(
    LoadSingleCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    emit(
      CalendarLoading(),
    );

    try {
      final List<GameLogDTO> gameLogs = await _getAllGameLogs();
      final List<DateTime> finishDates = await _getAllFinishDates();

      final Set<DateTime> logDates = gameLogs.fold(
        SplayTreeSet<DateTime>(),
        (Set<DateTime> previousDates, GameLogDTO log) =>
            previousDates..add(log.datetime),
      );

      DateTime selectedDate = DateTime.now();
      if (logDates.isNotEmpty) {
        selectedDate = logDates.last;
      }

      const CalendarRange range = CalendarRange.day;
      final List<GameLogDTO> selectedGameLogs =
          _selectedGameLogsInRange(gameLogs, selectedDate, range);

      final Duration selectedTotalTime =
          GameCalendarUtils.getTotalTime(selectedGameLogs);

      final bool isSelectedDateFinish =
          _isSelectedDateFinish(finishDates, selectedDate);

      emit(
        SingleCalendarLoaded(
          gameLogs,
          logDates,
          finishDates,
          selectedDate,
          selectedGameLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
        ),
      );
    } catch (e) {
      emit(
        CalendarNotLoaded(e.toString()),
      );
    }
  }

  void _mapUpdateSelectedDateToState(
    UpdateSelectedDate event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameLogDTO> gameLogs =
          (state as SingleCalendarLoaded).gameLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<DateTime> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      final DateTime previousSelectedDate =
          (state as SingleCalendarLoaded).selectedDate;

      List<GameLogDTO> selectedGameLogs;
      Duration selectedTotalTime;
      if (RangeListUtils.doesNewDateNeedRecalculation(
        event.date,
        previousSelectedDate,
        range,
      )) {
        selectedGameLogs =
            _selectedGameLogsInRange(gameLogs, event.date, range);

        selectedTotalTime = GameCalendarUtils.getTotalTime(selectedGameLogs);
      } else {
        selectedGameLogs = (state as SingleCalendarLoaded).selectedGameLogs;
        selectedTotalTime = (state as SingleCalendarLoaded).selectedTotalTime;
      }

      final bool isSelectedDateFinish =
          _isSelectedDateFinish(finishDates, event.date);

      emit(
        SingleCalendarLoaded(
          gameLogs,
          logDates,
          finishDates,
          event.date,
          selectedGameLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  void _mapUpdateSelectedDateFirstToState(
    UpdateSelectedDateFirst event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;

      if (logDates.isNotEmpty) {
        final DateTime firstDate = logDates.first;

        add(UpdateSelectedDate(firstDate));
      }
    }
  }

  void _mapUpdateSelectedDateLastToState(
    UpdateSelectedDateLast event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;

      if (logDates.isNotEmpty) {
        final DateTime lastDate = logDates.last;

        add(UpdateSelectedDate(lastDate));
      }
    }
  }

  void _mapUpdateSelectedDatePreviousToState(
    UpdateSelectedDatePrevious event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final DateTime previousDate =
          RangeListUtils.getPreviousDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(previousDate));
    }
  }

  void _mapUpdateSelectedDateNextToState(
    UpdateSelectedDateNext event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final DateTime nextDate =
          RangeListUtils.getNextDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(nextDate));
    }
  }

  void _mapUpdateRangeToState(
    UpdateCalendarRange event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameLogDTO> gameLogs =
          (state as SingleCalendarLoaded).gameLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<DateTime> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      final CalendarRange previousRange = (state as SingleCalendarLoaded).range;

      if (event.range != previousRange) {
        final List<GameLogDTO> selectedGameLogs =
            _selectedGameLogsInRange(gameLogs, selectedDate, event.range);

        final Duration selectedTotalTime =
            GameCalendarUtils.getTotalTime(selectedGameLogs);

        emit(
          SingleCalendarLoaded(
            gameLogs,
            logDates,
            finishDates,
            selectedDate,
            selectedGameLogs,
            isSelectedDateFinish,
            selectedTotalTime,
            event.range,
            style,
          ),
        );
      }
    }
  }

  void _mapUpdateStyleToState(
    UpdateCalendarStyle event,
    Emitter<CalendarState> emit,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameLogDTO> gameLogs =
          (state as SingleCalendarLoaded).gameLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<DateTime> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final List<GameLogDTO> selectedGameLogs =
          (state as SingleCalendarLoaded).selectedGameLogs;
      final bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;
      final Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;

      final int rotatingIndex =
          ((state as SingleCalendarLoaded).style.index + 1) %
              CalendarStyle.values.length;
      final CalendarStyle updatedStyle =
          CalendarStyle.values.elementAt(rotatingIndex);

      emit(
        SingleCalendarLoaded(
          gameLogs,
          logDates,
          finishDates,
          selectedDate,
          selectedGameLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          updatedStyle,
        ),
      );
    }
  }

  void _mapUpdateToState(
    UpdateSingleCalendar event,
    Emitter<CalendarState> emit,
  ) {
    emit(
      SingleCalendarLoaded(
        event.gameLogs,
        event.logDates,
        event.finishDates,
        event.selectedDate,
        event.selectedGameLogs,
        event.isSelectedDateFinish,
        event.selectedTotalTime,
        event.range,
        event.style,
      ),
    );
  }

  void _mapGameLogManagerStateToEvent(ItemRelationManagerState managerState) {
    if (managerState is ItemRelationAdded<GameLogDTO>) {
      _mapAddedGameLogToEvent(managerState);
    } else if (managerState is ItemRelationDeleted<GameLogDTO>) {
      _mapDeletedGameLogToEvent(managerState);
    }
  }

  void _mapFinishDateManagerStateToEvent(ItemRelationManagerState managerState) {
    if (managerState is ItemRelationAdded<ItemFinish>) {
      _mapAddedFinishDateToEvent(managerState);
    } else if (managerState is ItemRelationDeleted<ItemFinish>) {
      _mapDeletedFinishDateToEvent(managerState);
    }
  }

  void _mapAddedGameLogToEvent(ItemRelationAdded<GameLogDTO> managerState) {
    if (state is SingleCalendarLoaded) {
      final List<GameLogDTO> gameLogs =
          (state as SingleCalendarLoaded).gameLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<DateTime> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      List<GameLogDTO> selectedGameLogs =
          (state as SingleCalendarLoaded).selectedGameLogs;
      final bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final GameLogDTO addedGameLog = managerState.otherItem;

      if (gameLogs.isEmpty) {
        selectedDate = addedGameLog.datetime;
      }

      final List<GameLogDTO> updatedGameLogs = List<GameLogDTO>.from(gameLogs)
        ..add(addedGameLog);
      final Set<DateTime> updatedLogDates =
          SplayTreeSet<DateTime>.from(logDates)..add(addedGameLog.datetime);

      Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      if (range == CalendarRange.day &&
          addedGameLog.datetime.isSameDay(selectedDate)) {
        selectedGameLogs = List<GameLogDTO>.from(selectedGameLogs)
          ..add(addedGameLog);
        selectedGameLogs.sort();

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if (range == CalendarRange.week &&
          addedGameLog.datetime.isInWeekOf(selectedDate)) {
        final int weekIndex = addedGameLog.datetime.weekday - 1;
        final GameLogDTO dayGameLog = selectedGameLogs.elementAt(weekIndex);
        selectedGameLogs[weekIndex] = GameLogDTO(
          datetime: dayGameLog.datetime,
          time: dayGameLog.time + addedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if (range == CalendarRange.month &&
          addedGameLog.datetime.isInMonthAndYearOf(selectedDate)) {
        final int monthIndex = addedGameLog.datetime.day - 1;
        final GameLogDTO dayGameLog = selectedGameLogs.elementAt(monthIndex);
        selectedGameLogs[monthIndex] = GameLogDTO(
          datetime: dayGameLog.datetime,
          time: dayGameLog.time + addedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      } else if (range == CalendarRange.year &&
          addedGameLog.datetime.isInYearOf(selectedDate)) {
        final int yearIndex = addedGameLog.datetime.month - 1;
        final GameLogDTO monthGameLog = selectedGameLogs.elementAt(yearIndex);
        selectedGameLogs[yearIndex] = GameLogDTO(
          datetime: monthGameLog.datetime,
          time: monthGameLog.time + addedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime + addedGameLog.time;
      }

      add(
        UpdateSingleCalendar(
          updatedGameLogs,
          updatedLogDates,
          finishDates,
          selectedDate,
          selectedGameLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  void _mapDeletedGameLogToEvent(
    ItemRelationDeleted<GameLogDTO> managerState,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameLogDTO> gameLogs =
          (state as SingleCalendarLoaded).gameLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<DateTime> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      DateTime selectedDate = (state as SingleCalendarLoaded).selectedDate;
      List<GameLogDTO> selectedGameLogs =
          (state as SingleCalendarLoaded).selectedGameLogs;
      final bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;

      final GameLogDTO deletedGameLog = managerState.otherItem;

      final List<GameLogDTO> updatedGameLogs = gameLogs
          .where((GameLogDTO log) => log.datetime != deletedGameLog.datetime)
          .toList(growable: false);

      if (!updatedGameLogs.any(
        (GameLogDTO log) => log.datetime.isSameDay(deletedGameLog.datetime),
      )) {
        logDates.removeWhere(
          (DateTime date) => date.isSameDay(deletedGameLog.datetime),
        );
      }

      if (updatedGameLogs.isEmpty) {
        selectedDate = DateTime.now();
      }

      Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      if (range == CalendarRange.day &&
          deletedGameLog.datetime.isSameDay(selectedDate)) {
        selectedGameLogs = selectedGameLogs
            .where(
              (GameLogDTO log) => log.datetime != deletedGameLog.datetime,
            )
            .toList(growable: false);

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if (range == CalendarRange.week &&
          deletedGameLog.datetime.isInWeekOf(selectedDate)) {
        final int weekIndex = deletedGameLog.datetime.weekday - 1;
        final GameLogDTO dayGameLog = selectedGameLogs.elementAt(weekIndex);
        selectedGameLogs[weekIndex] = GameLogDTO(
          datetime: dayGameLog.datetime,
          time: dayGameLog.time - deletedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if (range == CalendarRange.month &&
          deletedGameLog.datetime.isInMonthAndYearOf(selectedDate)) {
        final int monthIndex = deletedGameLog.datetime.day - 1;
        final GameLogDTO dayGameLog = selectedGameLogs.elementAt(monthIndex);
        selectedGameLogs[monthIndex] = GameLogDTO(
          datetime: dayGameLog.datetime,
          time: dayGameLog.time - deletedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      } else if (range == CalendarRange.year &&
          deletedGameLog.datetime.isInYearOf(selectedDate)) {
        final int yearIndex = deletedGameLog.datetime.month - 1;
        final GameLogDTO monthGameLog = selectedGameLogs.elementAt(yearIndex);
        selectedGameLogs[yearIndex] = GameLogDTO(
          datetime: monthGameLog.datetime,
          time: monthGameLog.time - deletedGameLog.time,
        );

        selectedTotalTime = selectedTotalTime - deletedGameLog.time;
      }

      add(
        UpdateSingleCalendar(
          updatedGameLogs,
          logDates,
          finishDates,
          selectedDate,
          selectedGameLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  void _mapAddedFinishDateToEvent(ItemRelationAdded<ItemFinish> managerState) {
    if (state is SingleCalendarLoaded) {
      final List<GameLogDTO> gameLogs =
          (state as SingleCalendarLoaded).gameLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<DateTime> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final List<GameLogDTO> selectedGameLogs =
          (state as SingleCalendarLoaded).selectedGameLogs;
      final Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;

      final List<DateTime> updatedFinishDates = List<DateTime>.from(finishDates)
        ..add(managerState.otherItem.date);

      isSelectedDateFinish = isSelectedDateFinish ||
          managerState.otherItem.date.isSameDay(selectedDate);

      add(
        UpdateSingleCalendar(
          gameLogs,
          logDates,
          updatedFinishDates,
          selectedDate,
          selectedGameLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  void _mapDeletedFinishDateToEvent(
    ItemRelationDeleted<ItemFinish> managerState,
  ) {
    if (state is SingleCalendarLoaded) {
      final List<GameLogDTO> gameLogs =
          (state as SingleCalendarLoaded).gameLogs;
      final Set<DateTime> logDates = (state as SingleCalendarLoaded).logDates;
      final List<DateTime> finishDates =
          (state as SingleCalendarLoaded).finishDates;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;
      final List<GameLogDTO> selectedGameLogs =
          (state as SingleCalendarLoaded).selectedGameLogs;
      final Duration selectedTotalTime =
          (state as SingleCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      bool isSelectedDateFinish =
          (state as SingleCalendarLoaded).isSelectedDateFinish;

      final List<DateTime> updatedFinishDates = finishDates
          .where(
            (DateTime finish) => !finish.isSameDay(managerState.otherItem.date),
          )
          .toList(growable: false);

      isSelectedDateFinish = !(isSelectedDateFinish &&
          managerState.otherItem.date.isSameDay(selectedDate));

      add(
        UpdateSingleCalendar(
          gameLogs,
          logDates,
          updatedFinishDates,
          selectedDate,
          selectedGameLogs,
          isSelectedDateFinish,
          selectedTotalTime,
          range,
          style,
        ),
      );
    }
  }

  List<GameLogDTO> _selectedGameLogsInRange(
    List<GameLogDTO> gameLogs,
    DateTime selectedDate,
    CalendarRange range,
  ) {
    final List<GameLogDTO> selectedGameLogs =
        RangeListUtils.createGameLogListByRange(gameLogs, selectedDate, range);
    return selectedGameLogs..sort();
  }

  bool _isSelectedDateFinish(
    List<DateTime> finishDates,
    DateTime selectedDate,
  ) {
    return finishDates.any((DateTime finish) => finish.isSameDay(selectedDate));
  }

  @override
  Future<void> close() {
    gameLogManagerSubscription.cancel();
    finishDateManagerSubscription.cancel();
    return super.close();
  }

  Future<List<GameLogDTO>> _getAllGameLogs() {
    return gameLogService.getAll(itemId);
  }

  Future<List<DateTime>> _getAllFinishDates() {
    return gameFinishService.getAll(itemId);
  }
}
