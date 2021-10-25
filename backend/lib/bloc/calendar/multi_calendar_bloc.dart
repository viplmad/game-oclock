import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'package:backend/entity/entity.dart' show GameWithLogsEntity;
import 'package:backend/model/model.dart' show GameTimeLog, GameWithLogs;
import 'package:backend/mapper/mapper.dart' show GameTimeLogMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository, GameTimeLogRepository;
import 'package:backend/model/calendar_range.dart';
import 'package:backend/model/calendar_style.dart';

import '../bloc_utils.dart';
import 'multi_calendar.dart';
import 'range_list_utils.dart';


class MultiCalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  MultiCalendarBloc({
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameTimeLogRepository = collectionRepository.gameTimeLogRepository,
    this.gameRepository = collectionRepository.gameRepository,
    super(CalendarLoading()) {

      on<LoadMultiCalendar>(_mapLoadToState);
      on<UpdateSelectedDate>(_mapUpdateSelectedDateToState);
      on<UpdateCalendarRange>(_mapUpdateRangeToState);
      on<UpdateCalendarStyle>(_mapUpdateStyleToState);
      on<UpdateSelectedDateFirst>(_mapUpdateSelectedDateFirstToState);
      on<UpdateSelectedDateLast>(_mapUpdateSelectedDateLastToState);
      on<UpdateSelectedDatePrevious>(_mapUpdateSelectedDatePreviousToState);
      on<UpdateSelectedDateNext>(_mapUpdateSelectedDateNextToState);
      on<UpdateCalendarListItem>(_mapUpdateListItemToState);

    }

  final GameTimeLogRepository gameTimeLogRepository;
  final GameRepository gameRepository;
  final Set<int> yearsLoaded = Set<int>();

  void _checkConnection(Emitter<CalendarState> emit) async {

    await BlocUtils.checkConnection<GameTimeLogRepository, CalendarState, CalendarNotLoaded>(gameTimeLogRepository, emit, (final String error) => CalendarNotLoaded(error));

  }

  void _mapLoadToState(LoadMultiCalendar event, Emitter<CalendarState> emit) {

    if(event.year <= DateTime.now().year && yearsLoaded.add(event.year)) {

      if(state is MultiCalendarLoaded) {

        _mapLoadAdditionalCalendar(event.year, emit);

      } else {

        _mapLoadInitialCalendar(event.year, emit);

      }

    }

  }

  void _mapLoadInitialCalendar(int year, Emitter<CalendarState> emit) async {

    _checkConnection(emit);

    emit(
      CalendarLoading(),
    );

    try {

      final List<GameWithLogs> gamesWithLogs = await getReadAllGameWithTimeLogsInYearStream(year);

      final Set<DateTime> logDates = gamesWithLogs.fold(SplayTreeSet<DateTime>(), (Set<DateTime> previousDates, GameWithLogs gameWithLogs) => previousDates..addAll(gameWithLogs.logDates));

      DateTime selectedDate = DateTime.now();
      if(logDates.isNotEmpty) {
        selectedDate = logDates.last;
      }

      final CalendarRange range = CalendarRange.Day;
      final List<GameWithLogs> selectedGamesWithLogs = _selectedGameWithLogsInRange(gamesWithLogs, logDates, selectedDate, range);

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

      emit(
        CalendarNotLoaded(e.toString()),
      );

    }

  }

  void _mapLoadAdditionalCalendar(int year, Emitter<CalendarState> emit) async {

    _checkConnection(emit);

    try {

      final List<GameWithLogs> gamesWithLogs = List<GameWithLogs>.from((state as MultiCalendarLoaded).gamesWithLogs);
      final Set<DateTime> logDates = SplayTreeSet<DateTime>.from((state as MultiCalendarLoaded).logDates);
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final List<GameWithLogs> selectedGamesWithLogs = (state as MultiCalendarLoaded).selectedGamesWithLogs;
      final Duration selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as MultiCalendarLoaded).range;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;

      final DateTime focusedDate = DateTime(year, DateTime.december, 1);

      final List<GameWithLogs> yearGamesWithLogs = await getReadAllGameWithTimeLogsInYearStream(year);

      for(final GameWithLogs yearGameWithLogs in yearGamesWithLogs) {
        try {
          final GameWithLogs gameWithLogs = gamesWithLogs.singleWhere((GameWithLogs tempGameWithLogs) => tempGameWithLogs.game.uniqueId == yearGameWithLogs.game.uniqueId);
          gameWithLogs.timeLogs.addAll(yearGameWithLogs.timeLogs);
        } catch(IterableElementError) {
          gamesWithLogs.add(yearGameWithLogs);
        }
      }

      final Set<DateTime> yearLogDates = yearGamesWithLogs.fold(SplayTreeSet<DateTime>(), (Set<DateTime> previousDates, GameWithLogs yearGameWithLogs) => previousDates..addAll(yearGameWithLogs.logDates));
      logDates.addAll(yearLogDates);

      if(style == CalendarStyle.Graph) {
        final List<GameTimeLog> selectedTimeLogs = (state as MultiCalendarGraphLoaded).selectedTimeLogs;

        emit(
          MultiCalendarGraphLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedTimeLogs,
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

      emit(
        CalendarNotLoaded(e.toString()),
      );

    }

  }

  void _mapUpdateSelectedDateToState(UpdateSelectedDate event, Emitter<CalendarState> emit) {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final CalendarRange range = (state as MultiCalendarLoaded).range;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;
      final DateTime previousSelectedDate = (state as MultiCalendarLoaded).selectedDate;

      List<GameWithLogs> selectedGamesWithLogs;
      Duration selectedTotalTime;
      if(RangeListUtils.doesNewDateNeedRecalculation(event.date, previousSelectedDate, range)) {
        selectedGamesWithLogs = _selectedGameWithLogsInRange(gamesWithLogs, logDates, event.date, range);

        selectedTotalTime = _getTotalTime(selectedGamesWithLogs);
      } else {
        selectedGamesWithLogs = (state as MultiCalendarLoaded).selectedGamesWithLogs;
        selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
      }

      if(style == CalendarStyle.Graph) {
        final List<GameTimeLog> selectedTimeLogs =  _selectedTimeLogsInRange(selectedGamesWithLogs, event.date, range);

        emit(
          MultiCalendarGraphLoaded(
            gamesWithLogs,
            logDates,
            event.date,
            event.date,
            selectedGamesWithLogs,
            selectedTimeLogs,
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

  void _mapUpdateSelectedDateFirstToState(UpdateSelectedDateFirst event, Emitter<CalendarState> emit) {

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        final DateTime firstDate = logDates.first;

        add(UpdateSelectedDate(firstDate));
      }
    }

  }

  void _mapUpdateSelectedDateLastToState(UpdateSelectedDateLast event, Emitter<CalendarState> emit) {

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        final DateTime lastDate = logDates.last;

        add(UpdateSelectedDate(lastDate));
      }
    }

  }

  void _mapUpdateSelectedDatePreviousToState(UpdateSelectedDatePrevious event, Emitter<CalendarState> emit) {

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final CalendarRange range = (state as MultiCalendarLoaded).range;

      final DateTime previousDate = RangeListUtils.getPreviousDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(previousDate));
    }

  }

  void _mapUpdateSelectedDateNextToState(UpdateSelectedDateNext event, Emitter<CalendarState> emit) {

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final CalendarRange range = (state as MultiCalendarLoaded).range;

      final DateTime nextDate = RangeListUtils.getNextDateWithLogs(logDates, selectedDate, range);

      add(UpdateSelectedDate(nextDate));
    }

  }

  void _mapUpdateRangeToState(UpdateCalendarRange event, Emitter<CalendarState> emit) {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;
      final CalendarRange previousRange = (state as MultiCalendarLoaded).range;

      if(event.range != previousRange) {
        final List<GameWithLogs> selectedGamesWithLogs = _selectedGameWithLogsInRange(gamesWithLogs, logDates, selectedDate, event.range);

        final Duration selectedTotalTime = _getTotalTime(selectedGamesWithLogs);

        if(style == CalendarStyle.Graph) {
          final List<GameTimeLog> selectedTimeLogs = _selectedTimeLogsInRange(selectedGamesWithLogs, selectedDate, event.range);

          emit(
            MultiCalendarGraphLoaded(
              gamesWithLogs,
              logDates,
              focusedDate,
              selectedDate,
              selectedGamesWithLogs,
              selectedTimeLogs,
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

  void _mapUpdateStyleToState(UpdateCalendarStyle event, Emitter<CalendarState> emit) {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final List<GameWithLogs> selectedGamesWithLogs = (state as MultiCalendarLoaded).selectedGamesWithLogs;
      final Duration selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as MultiCalendarLoaded).range;

      final int rotatingIndex = ((state as MultiCalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      if(updatedStyle == CalendarStyle.List) {
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
      } else if(updatedStyle == CalendarStyle.Graph) {
        final List<GameTimeLog> selectedTimeLogs = _selectedTimeLogsInRange(selectedGamesWithLogs, selectedDate, range);

        emit(
          MultiCalendarGraphLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedTimeLogs,
            selectedTotalTime,
            range,
          ),
        );
      }
    }

  }

  void _mapUpdateListItemToState(UpdateCalendarListItem event, Emitter<CalendarState> emit) {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = List<GameWithLogs>.from((state as MultiCalendarLoaded).gamesWithLogs);
      final CalendarStyle style = (state as MultiCalendarLoaded).style;

      final int listItemIndex = gamesWithLogs.indexWhere((GameWithLogs item) => item.game.uniqueId == event.item.uniqueId);
      final GameWithLogs listItem = gamesWithLogs.elementAt(listItemIndex);

      if(listItem.game != event.item) {
        gamesWithLogs[listItemIndex] = GameWithLogs(game: event.item, timeLogs: listItem.timeLogs);

        final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
        final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
        final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
        final List<GameWithLogs> selectedGamesWithLogs = List<GameWithLogs>.from((state as MultiCalendarLoaded).selectedGamesWithLogs);
        final Duration selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
        final CalendarRange range = (state as MultiCalendarLoaded).range;

        final int selectedListItemIndex = selectedGamesWithLogs.indexWhere((GameWithLogs item) => item.game.uniqueId == event.item.uniqueId);

        if(selectedListItemIndex >= 0) {
          selectedGamesWithLogs[selectedListItemIndex] = gamesWithLogs[listItemIndex];
        }

        if(style == CalendarStyle.Graph) {
          final List<GameTimeLog> selectedTimeLogs = (state as MultiCalendarGraphLoaded).selectedTimeLogs;

          emit(
            MultiCalendarGraphLoaded(
              gamesWithLogs,
              logDates,
              focusedDate,
              selectedDate,
              selectedGamesWithLogs,
              selectedTimeLogs,
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
      }

    }

  }

  List<GameWithLogs> _selectedGameWithLogsInRange(List<GameWithLogs> gamesWithLogs, Set<DateTime> logDates, DateTime selectedDate, CalendarRange range) {
    final List<GameWithLogs> selectedGamesWithLogs = <GameWithLogs>[];

    bool Function(DateTime) dateComparer;
    switch(range) {
      case CalendarRange.Day:
        dateComparer = selectedDate.isSameDay;
        break;
      case CalendarRange.Week:
        dateComparer = selectedDate.isInWeekOf;
        break;
      case CalendarRange.Month:
        dateComparer = selectedDate.isInMonthAndYearOf;
        break;
      case CalendarRange.Year:
        dateComparer = selectedDate.isInYearOf;
        break;
    }

    if(logDates.any(dateComparer)) {
      for(final GameWithLogs gameWithLogs in gamesWithLogs) {
        final List<GameTimeLog> logs = gameWithLogs.timeLogs
          .where((GameTimeLog log) => dateComparer(log.dateTime))
          .toList(growable: false);

        if(logs.isNotEmpty) {
          selectedGamesWithLogs.add(
            GameWithLogs(
              game: gameWithLogs.game,
              timeLogs: logs,
            )
          );
        }
      }
    }

    return selectedGamesWithLogs..sort();
  }

  List<GameTimeLog> _selectedTimeLogsInRange(List<GameWithLogs> selectedGamesWithLogs, DateTime selectedDate, CalendarRange range) {
    List<GameTimeLog> selectedTimeLogs = <GameTimeLog>[];

    final List<GameTimeLog> timeLogs = selectedGamesWithLogs.fold<List<GameTimeLog>>(<GameTimeLog>[], (List<GameTimeLog> previousList, GameWithLogs gameWithLogs) => previousList..addAll(gameWithLogs.timeLogs));

    switch(range) {
      case CalendarRange.Day:
        selectedTimeLogs = timeLogs;
        break;
      default:
        selectedTimeLogs = RangeListUtils.createTimeLogListByRange(timeLogs, selectedDate, range);
        break;
    }

    return selectedTimeLogs;
  }

  Duration _getTotalTime(List<GameWithLogs> gamesWithLogs) {
    return gamesWithLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameWithLogs gameWithLogs) => previousDuration + gameWithLogs.totalTime);
  }

  @override
  Future<void> close() {

    return super.close();

  }

  @protected
  Future<List<GameWithLogs>> getReadAllGameWithTimeLogsInYearStream(int year) {

    final Future<List<GameWithLogsEntity>> entityListFuture = gameTimeLogRepository.findAllWithGameByYear(year);
    return GameTimeLogMapper.futureGameWithLogEntityListToModelList(entityListFuture, gameRepository.getImageURI);

  }
}