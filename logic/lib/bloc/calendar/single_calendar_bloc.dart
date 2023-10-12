import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:game_collection_client/api.dart' show GameLogDTO;

import 'package:logic/service/service.dart'
    show GameOClockService, GameLogService, GameFinishService;
import 'package:logic/model/model.dart' show CalendarRange, CalendarStyle;
import 'package:logic/utils/datetime_extension.dart';
import 'package:logic/utils/game_calendar_utils.dart';

import '../calendar_manager/calendar_manager.dart';
import '../item_relation_manager/item_relation_manager.dart';
import 'single_calendar.dart';
import 'range_list_utils.dart';

class SingleCalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  SingleCalendarBloc({
    required this.itemId,
    required GameOClockService collectionService,
    required this.managerBloc,
    required this.gameLogManagerBloc,
    required this.gameFinishManagerBloc,
  })  : _gameLogService = collectionService.gameLogService,
        _gameFinishService = collectionService.gameFinishService,
        super(CalendarLoading()) {
    on<LoadSingleCalendar>(_mapLoadToState);
    on<ReloadSingleCalendar>(_mapReloadToState);
    on<UpdateSelectedDate>(_mapUpdateSelectedDateToState);
    on<UpdateCalendarRange>(_mapUpdateRangeToState);
    on<UpdateCalendarStyle>(_mapUpdateStyleToState);
    on<UpdateSelectedDateFirst>(_mapUpdateSelectedDateFirstToState);
    on<UpdateSelectedDateLast>(_mapUpdateSelectedDateLastToState);
    on<UpdateSelectedDatePrevious>(_mapUpdateSelectedDatePreviousToState);
    on<UpdateSelectedDateNext>(_mapUpdateSelectedDateNextToState);
    on<UpdateSingleCalendar>(_mapUpdateToState);

    _gameLogManagerSubscription =
        gameLogManagerBloc.stream.listen(_mapGameLogManagerStateToEvent);
    _finishDateManagerSubscription =
        gameFinishManagerBloc.stream.listen(_mapFinishDateManagerStateToEvent);
  }

  final String itemId;
  final CalendarManagerBloc managerBloc;
  final GameLogRelationManagerBloc gameLogManagerBloc;
  final GameFinishRelationManagerBloc gameFinishManagerBloc;

  final GameLogService _gameLogService;
  final GameFinishService _gameFinishService;

  late final StreamSubscription<ItemRelationManagerState>
      _gameLogManagerSubscription;
  late final StreamSubscription<ItemRelationManagerState>
      _finishDateManagerSubscription;

  void _mapLoadToState(
    LoadSingleCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    emit(
      CalendarLoading(),
    );

    await _mapAnyLoadToState(emit);
  }

  void _mapReloadToState(
    ReloadSingleCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is SingleCalendarLoaded) {
      final CalendarRange range = (state as SingleCalendarLoaded).range;
      final CalendarStyle style = (state as SingleCalendarLoaded).style;
      final DateTime selectedDate =
          (state as SingleCalendarLoaded).selectedDate;

      emit(
        CalendarLoading(),
      );

      try {
        final List<GameLogDTO> gameLogs = await _getAllGameLogs();
        final List<DateTime> finishDates = await _getAllFinishDates();

        final Set<DateTime> logDates = gameLogs.fold(
          SplayTreeSet<DateTime>(),
          (Set<DateTime> previousDates, GameLogDTO log) =>
              previousDates..add(log.startDatetime),
        );

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
            style,
          ),
        );
      } catch (e) {
        managerBloc.add(WarnCalendarNotLoaded(e.toString()));
        emit(
          CalendarError(),
        );
      }
    } else {
      await _mapAnyLoadToState(emit);
    }
  }

  Future<void> _mapAnyLoadToState(Emitter<CalendarState> emit) async {
    try {
      final List<GameLogDTO> gameLogs = await _getAllGameLogs();
      final List<DateTime> finishDates = await _getAllFinishDates();

      final Set<DateTime> logDates = gameLogs.fold(
        SplayTreeSet<DateTime>(),
        (Set<DateTime> previousDates, GameLogDTO log) =>
            previousDates..add(log.startDatetime),
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
      managerBloc.add(WarnCalendarNotLoaded(e.toString()));
      emit(
        CalendarError(),
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
    if (managerState is ItemRelationAdded) {
      _mapAddedGameLogToEvent(managerState);
    } else if (managerState is ItemRelationDeleted) {
      _mapDeletedGameLogToEvent(managerState);
    }
  }

  void _mapFinishDateManagerStateToEvent(
    ItemRelationManagerState managerState,
  ) {
    if (managerState is ItemRelationAdded) {
      _mapAddedFinishDateToEvent(managerState);
    } else if (managerState is ItemRelationDeleted) {
      _mapDeletedFinishDateToEvent(managerState);
    }
  }

  void _mapAddedGameLogToEvent(ItemRelationAdded managerState) {
    add(ReloadSingleCalendar());
  }

  void _mapDeletedGameLogToEvent(ItemRelationDeleted managerState) {
    add(ReloadSingleCalendar());
  }

  void _mapAddedFinishDateToEvent(ItemRelationAdded managerState) {
    add(ReloadSingleCalendar());
  }

  void _mapDeletedFinishDateToEvent(ItemRelationDeleted managerState) {
    add(ReloadSingleCalendar());
  }

  List<GameLogDTO> _selectedGameLogsInRange(
    List<GameLogDTO> gameLogs,
    DateTime selectedDate,
    CalendarRange range,
  ) {
    final List<GameLogDTO> selectedGameLogs =
        RangeListUtils.createGameLogListByRange(gameLogs, selectedDate, range);
    return selectedGameLogs
      ..sort(GameCalendarUtils.logComparatorEarlierFirst());
  }

  bool _isSelectedDateFinish(
    List<DateTime> finishDates,
    DateTime selectedDate,
  ) {
    return finishDates.any((DateTime finish) => finish.isSameDay(selectedDate));
  }

  @override
  Future<void> close() {
    _gameLogManagerSubscription.cancel();
    _finishDateManagerSubscription.cancel();
    return super.close();
  }

  Future<List<GameLogDTO>> _getAllGameLogs() {
    return _gameLogService.getAll(itemId);
  }

  Future<List<DateTime>> _getAllFinishDates() {
    return _gameFinishService.getAll(itemId);
  }
}
