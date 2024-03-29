import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:game_oclock_client/api.dart'
    show ErrorCode, GameLogDTO, GameWithLogsDTO;

import 'package:logic/model/model.dart' show CalendarRange, CalendarStyle;
import 'package:logic/service/service.dart'
    show GameOClockService, GameLogService;
import 'package:logic/bloc/bloc_utils.dart';
import 'package:logic/utils/datetime_extension.dart';
import 'package:logic/utils/game_calendar_utils.dart';

import '../calendar_manager/calendar_manager.dart';
import 'multi_calendar.dart';
import 'range_list_utils.dart';

class MultiCalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  MultiCalendarBloc({
    required GameOClockService collectionService,
    required this.managerBloc,
  })  : _gameLogService = collectionService.gameLogService,
        super(CalendarLoading()) {
    on<LoadMultiCalendar>(_mapLoadToState);
    on<ReloadMultiCalendar>(_mapReloadToState);
    on<UpdateSelectedDate>(_mapUpdateSelectedDateToState);
    on<UpdateCalendarRange>(_mapUpdateRangeToState);
    on<UpdateCalendarStyle>(_mapUpdateStyleToState);
    on<UpdateSelectedDateFirst>(_mapUpdateSelectedDateFirstToState);
    on<UpdateSelectedDateLast>(_mapUpdateSelectedDateLastToState);
    on<UpdateSelectedDatePrevious>(_mapUpdateSelectedDatePreviousToState);
    on<UpdateSelectedDateNext>(_mapUpdateSelectedDateNextToState);
  }

  final CalendarManagerBloc managerBloc;

  final GameLogService _gameLogService;
  final Set<int> _yearsLoaded = <int>{};

  void _mapLoadToState(
    LoadMultiCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    if (event.year <= DateTime.now().year && _yearsLoaded.add(event.year)) {
      if (state is MultiCalendarLoaded) {
        await _mapLoadAdditionalCalendar(event.year, emit);
      } else {
        await _mapLoadInitialCalendar(event.year, emit);
      }
    }
  }

  void _mapReloadToState(
    ReloadMultiCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    _yearsLoaded.clear();

    if (state is MultiCalendarLoaded) {
      final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final CalendarRange range = (state as MultiCalendarLoaded).range;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;

      final int year = focusedDate.year;

      emit(
        CalendarLoading(),
      );

      try {
        final List<GameWithLogsDTO> gamesWithLogs =
            await _getAllGameWithLogsInYear(year);

        final Set<DateTime> logDates = gamesWithLogs.fold(
          SplayTreeSet<DateTime>(),
          (Set<DateTime> previousDates, GameWithLogsDTO gameWithLogs) =>
              previousDates
                ..addAll(
                  GameCalendarUtils.getUniqueLogDates(gameWithLogs.logs),
                ),
        );

        final List<GameWithLogsDTO> selectedGamesWithLogs =
            _selectedGameWithLogsInRange(
          gamesWithLogs,
          logDates,
          selectedDate,
          range,
        );

        final Duration selectedTotalTime = _getTotalTime(selectedGamesWithLogs);

        emit(
          MultiCalendarLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedTotalTime,
            range,
            style,
          ),
        );
      } catch (e) {
        _handleError(e, emit);
      }
    } else if (state is! CalendarLoading) {
      await _mapLoadInitialCalendar(DateTime.now().year, emit);
    }
  }

  Future<void> _mapLoadInitialCalendar(
    int year,
    Emitter<CalendarState> emit,
  ) async {
    emit(
      CalendarLoading(),
    );

    try {
      final List<GameWithLogsDTO> gamesWithLogs =
          await _getAllGameWithLogsInYear(year);

      final Set<DateTime> logDates = gamesWithLogs.fold(
        SplayTreeSet<DateTime>(),
        (Set<DateTime> previousDates, GameWithLogsDTO gameWithLogs) =>
            previousDates
              ..addAll(GameCalendarUtils.getUniqueLogDates(gameWithLogs.logs)),
      );

      DateTime selectedDate = DateTime.now();
      if (logDates.isNotEmpty) {
        selectedDate = logDates.last;
      }

      const CalendarRange range = CalendarRange.day;
      final List<GameWithLogsDTO> selectedGamesWithLogs =
          _selectedGameWithLogsInRange(
        gamesWithLogs,
        logDates,
        selectedDate,
        range,
      );

      final Duration selectedTotalTime = _getTotalTime(selectedGamesWithLogs);

      emit(
        MultiCalendarLoaded(
          gamesWithLogs,
          logDates,
          selectedDate,
          selectedDate,
          selectedGamesWithLogs,
          selectedTotalTime,
          range,
        ),
      );
    } catch (e) {
      _handleError(e, emit);
    }
  }

  Future<void> _mapLoadAdditionalCalendar(
    int year,
    Emitter<CalendarState> emit,
  ) async {
    try {
      final List<GameWithLogsDTO> gamesWithLogs = List<GameWithLogsDTO>.from(
        (state as MultiCalendarLoaded).gamesWithLogs,
      );
      final Set<DateTime> logDates =
          SplayTreeSet<DateTime>.from((state as MultiCalendarLoaded).logDates);
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final List<GameWithLogsDTO> selectedGamesWithLogs =
          (state as MultiCalendarLoaded).selectedGamesWithLogs;
      final Duration selectedTotalTime =
          (state as MultiCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as MultiCalendarLoaded).range;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;

      final DateTime focusedDate = DateTime(year, DateTime.december, 1);

      final List<GameWithLogsDTO> yearGamesWithLogs =
          await _getAllGameWithLogsInYear(year);

      for (final GameWithLogsDTO yearGameWithLogs in yearGamesWithLogs) {
        try {
          final GameWithLogsDTO gameWithLogs = gamesWithLogs.singleWhere(
            (GameWithLogsDTO tempGameWithLogs) =>
                tempGameWithLogs.id == yearGameWithLogs.id,
          );
          gameWithLogs.logs.addAll(yearGameWithLogs.logs);
        } catch (iterableElementError) {
          gamesWithLogs.add(yearGameWithLogs);
        }
      }

      final Set<DateTime> yearLogDates = yearGamesWithLogs.fold(
        SplayTreeSet<DateTime>(),
        (Set<DateTime> previousDates, GameWithLogsDTO yearGameWithLogs) =>
            previousDates
              ..addAll(
                GameCalendarUtils.getUniqueLogDates(yearGameWithLogs.logs),
              ),
      );
      logDates.addAll(yearLogDates);

      if (style == CalendarStyle.graph) {
        final List<GameLogDTO> selectedGameLogs =
            (state as MultiCalendarGraphLoaded).selectedGameLogs;

        emit(
          MultiCalendarGraphLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedGameLogs,
            selectedTotalTime,
            range,
          ),
        );
      } else {
        emit(
          MultiCalendarLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedTotalTime,
            range,
          ),
        );
      }
    } catch (e) {
      _handleError(e, emit);
    }
  }

  void _mapUpdateSelectedDateToState(
    UpdateSelectedDate event,
    Emitter<CalendarState> emit,
  ) {
    if (state is MultiCalendarLoaded) {
      final List<GameWithLogsDTO> gamesWithLogs =
          (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final CalendarRange range = (state as MultiCalendarLoaded).range;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;
      final DateTime previousSelectedDate =
          (state as MultiCalendarLoaded).selectedDate;

      List<GameWithLogsDTO> selectedGamesWithLogs;
      Duration selectedTotalTime;
      if (RangeListUtils.doesNewDateNeedRecalculation(
        event.date,
        previousSelectedDate,
        range,
      )) {
        selectedGamesWithLogs = _selectedGameWithLogsInRange(
          gamesWithLogs,
          logDates,
          event.date,
          range,
        );

        selectedTotalTime = _getTotalTime(selectedGamesWithLogs);
      } else {
        selectedGamesWithLogs =
            (state as MultiCalendarLoaded).selectedGamesWithLogs;
        selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
      }

      if (style == CalendarStyle.graph) {
        final List<GameLogDTO> selectedGameLogs =
            _selectedGameLogsInRange(selectedGamesWithLogs, event.date, range);

        emit(
          MultiCalendarGraphLoaded(
            gamesWithLogs,
            logDates,
            event.date,
            event.date,
            selectedGamesWithLogs,
            selectedGameLogs,
            selectedTotalTime,
            range,
          ),
        );
      } else {
        emit(
          MultiCalendarLoaded(
            gamesWithLogs,
            logDates,
            event.date,
            event.date,
            selectedGamesWithLogs,
            selectedTotalTime,
            range,
          ),
        );
      }
    }
  }

  void _mapUpdateSelectedDateFirstToState(
    UpdateSelectedDateFirst event,
    Emitter<CalendarState> emit,
  ) {
    if (state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;

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
    if (state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;

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
    if (state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final CalendarRange range = (state as MultiCalendarLoaded).range;

      final DateTime previousDate =
          RangeListUtils.getPreviousDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(previousDate));
    }
  }

  void _mapUpdateSelectedDateNextToState(
    UpdateSelectedDateNext event,
    Emitter<CalendarState> emit,
  ) {
    if (state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final CalendarRange range = (state as MultiCalendarLoaded).range;

      final DateTime nextDate =
          RangeListUtils.getNextDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(nextDate));
    }
  }

  void _mapUpdateRangeToState(
    UpdateCalendarRange event,
    Emitter<CalendarState> emit,
  ) {
    if (state is MultiCalendarLoaded) {
      final List<GameWithLogsDTO> gamesWithLogs =
          (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;
      final CalendarRange previousRange = (state as MultiCalendarLoaded).range;

      if (event.range != previousRange) {
        final List<GameWithLogsDTO> selectedGamesWithLogs =
            _selectedGameWithLogsInRange(
          gamesWithLogs,
          logDates,
          selectedDate,
          event.range,
        );

        final Duration selectedTotalTime = _getTotalTime(selectedGamesWithLogs);

        if (style == CalendarStyle.graph) {
          final List<GameLogDTO> selectedGameLogs = _selectedGameLogsInRange(
            selectedGamesWithLogs,
            selectedDate,
            event.range,
          );

          emit(
            MultiCalendarGraphLoaded(
              gamesWithLogs,
              logDates,
              focusedDate,
              selectedDate,
              selectedGamesWithLogs,
              selectedGameLogs,
              selectedTotalTime,
              event.range,
            ),
          );
        } else {
          emit(
            MultiCalendarLoaded(
              gamesWithLogs,
              logDates,
              focusedDate,
              selectedDate,
              selectedGamesWithLogs,
              selectedTotalTime,
              event.range,
            ),
          );
        }
      }
    }
  }

  void _mapUpdateStyleToState(
    UpdateCalendarStyle event,
    Emitter<CalendarState> emit,
  ) {
    if (state is MultiCalendarLoaded) {
      final List<GameWithLogsDTO> gamesWithLogs =
          (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final List<GameWithLogsDTO> selectedGamesWithLogs =
          (state as MultiCalendarLoaded).selectedGamesWithLogs;
      final Duration selectedTotalTime =
          (state as MultiCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as MultiCalendarLoaded).range;

      final int rotatingIndex =
          ((state as MultiCalendarLoaded).style.index + 1) %
              CalendarStyle.values.length;
      final CalendarStyle updatedStyle =
          CalendarStyle.values.elementAt(rotatingIndex);

      if (updatedStyle == CalendarStyle.list) {
        emit(
          MultiCalendarLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedTotalTime,
            range,
          ),
        );
      } else if (updatedStyle == CalendarStyle.graph) {
        final List<GameLogDTO> selectedGameLogs = _selectedGameLogsInRange(
          selectedGamesWithLogs,
          selectedDate,
          range,
        );

        emit(
          MultiCalendarGraphLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedGameLogs,
            selectedTotalTime,
            range,
          ),
        );
      }
    }
  }

  void _handleError(Object e, Emitter<CalendarState> emit) {
    BlocUtils.handleErrorWithManager(
      e,
      emit,
      managerBloc,
      () => CalendarError(),
      (ErrorCode error, String errorDescription) =>
          WarnCalendarNotLoaded(error, errorDescription),
    );
  }

  List<GameWithLogsDTO> _selectedGameWithLogsInRange(
    List<GameWithLogsDTO> gamesWithLogs,
    Set<DateTime> logDates,
    DateTime selectedDate,
    CalendarRange range,
  ) {
    final List<GameWithLogsDTO> selectedGamesWithLogs = <GameWithLogsDTO>[];

    bool Function(DateTime) dateComparer;
    switch (range) {
      case CalendarRange.day:
        dateComparer = selectedDate.isSameDay;
        break;
      case CalendarRange.week:
        dateComparer = selectedDate.isInWeekOf;
        break;
      case CalendarRange.month:
        dateComparer = selectedDate.isInMonthAndYearOf;
        break;
      case CalendarRange.year:
        dateComparer = selectedDate.isInYearOf;
        break;
    }

    if (logDates.any(dateComparer)) {
      for (final GameWithLogsDTO gameWithLogs in gamesWithLogs) {
        final List<GameLogDTO> logs = gameWithLogs.logs
            .where((GameLogDTO log) => dateComparer(log.startDatetime))
            .toList(growable: false);

        if (logs.isNotEmpty) {
          selectedGamesWithLogs.add(
            GameWithLogsDTO.withLogs(gameWithLogs, logs),
          );
        }
      }
    }

    // Populate totalTime before sorting and getting totalTime for selectedDate
    _populateTotalTime(selectedGamesWithLogs);

    return selectedGamesWithLogs
      ..sort(GameCalendarUtils.logsComparatorMostTimeFirst());
  }

  List<GameLogDTO> _selectedGameLogsInRange(
    List<GameWithLogsDTO> selectedGamesWithLogs,
    DateTime selectedDate,
    CalendarRange range,
  ) {
    List<GameLogDTO> selectedGameLogs = <GameLogDTO>[];

    final List<GameLogDTO> gameLogs =
        selectedGamesWithLogs.fold<List<GameLogDTO>>(
      <GameLogDTO>[],
      (List<GameLogDTO> previousList, GameWithLogsDTO gameWithLogs) =>
          previousList..addAll(gameWithLogs.logs),
    );

    switch (range) {
      case CalendarRange.day:
        selectedGameLogs = gameLogs;
        break;
      default:
        selectedGameLogs = RangeListUtils.createGameLogListByRange(
          gameLogs,
          selectedDate,
          range,
        );
        break;
    }

    return selectedGameLogs;
  }

  void _populateTotalTime(List<GameWithLogsDTO> gamesWithLogs) {
    for (final GameWithLogsDTO gameWithLogs in gamesWithLogs) {
      gameWithLogs.totalTime =
          GameCalendarUtils.getTotalTime(gameWithLogs.logs);
    }
  }

  Duration _getTotalTime(List<GameWithLogsDTO> gamesWithLogs) {
    return gamesWithLogs.fold<Duration>(
      const Duration(),
      (Duration previousDuration, GameWithLogsDTO gameWithLogs) =>
          previousDuration + (gameWithLogs.totalTime ?? const Duration()),
    );
  }

  Future<List<GameWithLogsDTO>> _getAllGameWithLogsInYear(int year) {
    final DateTime yearDate = DateTime(year);
    final DateTime firstDayYear = yearDate.atFirstDayOfYear();
    final DateTime lastDayYear = yearDate.atLastDayOfYear();

    return _gameLogService.getPlayedGames(firstDayYear, lastDayYear);
  }
}
