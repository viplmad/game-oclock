import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'package:backend/entity/entity.dart' show GameWithLogsEntity;
import 'package:backend/model/model.dart' show GameTimeLog, GameWithLogs;
import 'package:backend/mapper/mapper.dart' show GameTimeLogMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository, GameTimeLogRepository;
import 'package:backend/model/calendar_range.dart';
import 'package:backend/model/calendar_style.dart';

import 'multi_calendar.dart';
import 'range_list_utils.dart';


class MultiCalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  MultiCalendarBloc({
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameTimeLogRepository = collectionRepository.gameTimeLogRepository,
    this.gameRepository = collectionRepository.gameRepository,
    super(CalendarLoading());

  final GameTimeLogRepository gameTimeLogRepository;
  final GameRepository gameRepository;
  final Set<int> yearsLoaded = Set<int>();

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {

    yield* _checkConnection();

    if(event is LoadMultiCalendar) {

      yield* _mapLoadToState(event);

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

    } else if(event is UpdateCalendarListItem) {

      yield* _mapUpdateListItemToState(event);

    }

  }

  Stream<CalendarState> _checkConnection() async* {

    if(gameTimeLogRepository.isClosed()) {
      yield const CalendarNotLoaded('Connection lost. Trying to reconnect');

      try {

        gameTimeLogRepository.reconnect();
        await gameTimeLogRepository.open();

      } catch (e) {

        yield CalendarNotLoaded(e.toString());

      }
    }

  }

  Stream<CalendarState> _mapLoadToState(LoadMultiCalendar event) async* {

    if(event.year <= DateTime.now().year && yearsLoaded.add(event.year)) {

      if(state is MultiCalendarLoaded) {

        yield* _mapLoadAdditionalCalendar(event.year);

      } else {

        yield* _mapLoadInitialCalendar(event.year);

      }

    }

  }

  Stream<CalendarState> _mapLoadInitialCalendar(int year) async* {

    yield CalendarLoading();

    try {

      final List<GameWithLogs> gamesWithLogs = await getReadAllGameWithTimeLogsInYearStream(year);

      final Set<DateTime> logDates = gamesWithLogs.fold(SplayTreeSet<DateTime>(), (Set<DateTime> previousDates, GameWithLogs gameWithLogs) => previousDates..addAll(gameWithLogs.logDates));

      DateTime selectedDate = DateTime.now();
      if(logDates.isNotEmpty) {
        selectedDate = logDates.last;
      }

      final CalendarRange range = CalendarRange.Day;
      final List<GameWithLogs> selectedGamesWithLogs = _selectedGameWithLogsInRange(gamesWithLogs, logDates, selectedDate, range);

      final Duration selectedTotalTime = selectedGamesWithLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameWithLogs gameWithLogs) => previousDuration + gameWithLogs.totalTime);

      yield MultiCalendarListLoaded(
        gamesWithLogs,
        logDates,
        selectedDate,
        selectedDate,
        selectedGamesWithLogs,
        selectedTotalTime,
        range,
      );

    } catch (e) {

      yield CalendarNotLoaded(e.toString());

    }

  }

  Stream<CalendarState> _mapLoadAdditionalCalendar(int year) async* {

    try {

      final List<GameWithLogs> gamesWithLogs = List<GameWithLogs>.from((state as MultiCalendarLoaded).gamesWithLogs);
      final Set<DateTime> logDates = SplayTreeSet<DateTime>.from((state as MultiCalendarLoaded).logDates);
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
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

      if(style == CalendarStyle.List) {
        final List<GameWithLogs> selectedGamesWithLogs = (state as MultiCalendarListLoaded).selectedGamesWithLogs;

        yield MultiCalendarListLoaded(
          gamesWithLogs,
          logDates,
          focusedDate,
          selectedDate,
          selectedGamesWithLogs,
          selectedTotalTime,
          range,
        );
      } else if(style == CalendarStyle.Graph) {
        final List<GameTimeLog> selectedTimeLogs = (state as MultiCalendarGraphLoaded).selectedTimeLogs;

        yield MultiCalendarGraphLoaded(
          gamesWithLogs,
          logDates,
          focusedDate,
          selectedDate,
          selectedTimeLogs,
          selectedTotalTime,
          range,
        );
      }

    } catch (e) {

      yield CalendarNotLoaded(e.toString());

    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateToState(UpdateSelectedDate event) async* {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final CalendarRange range = (state as MultiCalendarLoaded).range;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;
      final DateTime previousSelectedDate = (state as MultiCalendarLoaded).selectedDate;

      if(style == CalendarStyle.List) {
        List<GameWithLogs> selectedGamesWithLogs;
        Duration selectedTotalTime;
        if(RangeListUtils.doesNewDateNeedRecalculation(event.date, previousSelectedDate, range)) {
          selectedGamesWithLogs = _selectedGameWithLogsInRange(gamesWithLogs, logDates, event.date, range);

          selectedTotalTime = selectedGamesWithLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameWithLogs gameWithLogs) => previousDuration + gameWithLogs.totalTime);
        } else {
          selectedGamesWithLogs = (state as MultiCalendarListLoaded).selectedGamesWithLogs;
          selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
        }

        yield MultiCalendarListLoaded(
          gamesWithLogs,
          logDates,
          event.date,
          event.date,
          selectedGamesWithLogs,
          selectedTotalTime,
          range,
        );
      } else if(style == CalendarStyle.Graph) {
        List<GameTimeLog> selectedTimeLogs;
        Duration selectedTotalTime;
        if(RangeListUtils.doesNewDateNeedRecalculation(event.date, previousSelectedDate, range)) {
          selectedTimeLogs = _selectedTimeLogsInRange(gamesWithLogs, logDates, event.date, range);

          selectedTotalTime = selectedTimeLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameTimeLog log) => previousDuration + log.time);
        } else {
          selectedTimeLogs = (state as MultiCalendarGraphLoaded).selectedTimeLogs;
          selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
        }

        yield MultiCalendarGraphLoaded(
          gamesWithLogs,
          logDates,
          event.date,
          event.date,
          selectedTimeLogs,
          selectedTotalTime,
          range,
        );
      }
    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateFirstToState(UpdateSelectedDateFirst event) async* {

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        final DateTime firstDate = logDates.first;

        add(UpdateSelectedDate(firstDate));
      }
    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateLastToState(UpdateSelectedDateLast event) async* {

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        final DateTime lastDate = logDates.last;

        add(UpdateSelectedDate(lastDate));
      }
    }

  }

  Stream<CalendarState> _mapUpdateSelectedDatePreviousToState(UpdateSelectedDatePrevious event) async* {

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;

      DateTime? previousDate;
      if(logDates.isNotEmpty) {
        final List<DateTime> listLogDates = logDates.toList(growable: false);
        int selectedIndex = listLogDates.indexWhere((DateTime date) => date.isSameDay(selectedDate));
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

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;

      DateTime? nextDate;
      if(logDates.isNotEmpty) {
        final List<DateTime> listLogDates = logDates.toList(growable: false);
        int selectedIndex = listLogDates.indexWhere((DateTime date) => date.isSameDay(selectedDate));
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

  Stream<CalendarState> _mapUpdateRangeToState(UpdateCalendarRange event) async* {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;
      final CalendarRange previousRange = (state as MultiCalendarLoaded).range;

      if(event.range != previousRange) {
        if(style == CalendarStyle.List) {
          final List<GameWithLogs> selectedGamesWithLogs = _selectedGameWithLogsInRange(gamesWithLogs, logDates, selectedDate, event.range);

          final Duration selectedTotalTime = selectedGamesWithLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameWithLogs gameWithLogs) => previousDuration + gameWithLogs.totalTime);

          yield MultiCalendarListLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedTotalTime,
            event.range,
          );
        } else if(style == CalendarStyle.Graph) {
          final List<GameTimeLog> selectedTimeLogs = _selectedTimeLogsInRange(gamesWithLogs, logDates, selectedDate, event.range);

          final Duration selectedTotalTime = selectedTimeLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameTimeLog log) => previousDuration + log.time);

          yield MultiCalendarGraphLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedTimeLogs,
            selectedTotalTime,
            event.range,
          );
        }
      }
    }
  }

  Stream<CalendarState> _mapUpdateStyleToState(UpdateCalendarStyle event) async* {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final Duration selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
      final CalendarRange range = (state as MultiCalendarLoaded).range;

      final int rotatingIndex = ((state as MultiCalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      if(updatedStyle == CalendarStyle.List) {
        final List<GameWithLogs> selectedGamesWithLogs = _selectedGameWithLogsInRange(gamesWithLogs, logDates, selectedDate, range);

        yield MultiCalendarListLoaded(
          gamesWithLogs,
          logDates,
          focusedDate,
          selectedDate,
          selectedGamesWithLogs,
          selectedTotalTime,
          range,
        );
      } else if(updatedStyle == CalendarStyle.Graph) {
        final List<GameTimeLog> selectedTimeLogs = _selectedTimeLogsInRange(gamesWithLogs, logDates, selectedDate, range);

        yield MultiCalendarGraphLoaded(
          gamesWithLogs,
          logDates,
          focusedDate,
          selectedDate,
          selectedTimeLogs,
          selectedTotalTime,
          range,
        );
      }
    }

  }

  Stream<CalendarState> _mapUpdateListItemToState(UpdateCalendarListItem event) async* {

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
        final Duration selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
        final CalendarRange range = (state as MultiCalendarLoaded).range;

        if(style == CalendarStyle.List) {
          final List<GameWithLogs> selectedGamesWithLogs = List<GameWithLogs>.from((state as MultiCalendarListLoaded).selectedGamesWithLogs);
          final int selectedListItemIndex = selectedGamesWithLogs.indexWhere((GameWithLogs item) => item.game.uniqueId == event.item.uniqueId);

          if(selectedListItemIndex >= 0) {
            selectedGamesWithLogs[selectedListItemIndex] = gamesWithLogs[listItemIndex];
          }

          yield MultiCalendarListLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedGamesWithLogs,
            selectedTotalTime,
            range,
          );
        } else if(style == CalendarStyle.Graph) {
          final List<GameTimeLog> selectedTimeLogs = (state as MultiCalendarGraphLoaded).selectedTimeLogs;

          yield MultiCalendarGraphLoaded(
            gamesWithLogs,
            logDates,
            focusedDate,
            selectedDate,
            selectedTimeLogs,
            selectedTotalTime,
            range,
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

  List<GameTimeLog> _selectedTimeLogsInRange(List<GameWithLogs> gamesWithLogs, Set<DateTime> logDates, DateTime selectedDate, CalendarRange range) {
    List<GameTimeLog> selectedTimeLogs = <GameTimeLog>[];

    final List<GameWithLogs> selectedGameWithLogs = _selectedGameWithLogsInRange(gamesWithLogs, logDates, selectedDate, range);
    final List<GameTimeLog> timeLogs = selectedGameWithLogs.fold<List<GameTimeLog>>(<GameTimeLog>[], (List<GameTimeLog> previousList, GameWithLogs gameWithLogs) => previousList..addAll(gameWithLogs.timeLogs));

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

  @override
  Future<void> close() {

    return super.close();

  }

  Future<List<GameWithLogs>> getReadAllGameWithTimeLogsInYearStream(int year) {

    final Future<List<GameWithLogsEntity>> entityListFuture = gameTimeLogRepository.findAllWithGameByYear(year);
    return GameTimeLogMapper.futureGameWithLogEntityListToModelList(entityListFuture, gameRepository.getImageURI);

  }
}