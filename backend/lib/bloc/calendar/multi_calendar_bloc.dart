import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'package:backend/model/model.dart';
import 'package:backend/model/calendar_style.dart';

import 'package:backend/repository/item_repository.dart';

import 'multi_calendar.dart';


class MultiCalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  MultiCalendarBloc({
    required this.iCollectionRepository,
  }) : super(CalendarLoading());

  final ItemRepository iCollectionRepository;
  final Set<int> yearsLoaded = Set<int>();

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {

    yield* _checkConnection();

    if(event is LoadMultiCalendar) {

      yield* _mapLoadToState(event);

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

    } else if(event is UpdateMultiCalendar) {

      yield* _mapUpdateToState(event);

    } else if(event is UpdateCalendarListItem) {

      yield* _mapUpdateListItemToState(event);

    }

  }

  Stream<CalendarState> _checkConnection() async* {

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

      final List<GameWithLogs> gamesWithLogs = await getReadAllGameWithTimeLogsInYearStream(year).first;

      final Set<DateTime> logDates = gamesWithLogs.fold(SplayTreeSet<DateTime>(), (Set<DateTime> previousDates, GameWithLogs gameWithLogs) => previousDates..addAll(gameWithLogs.logDates));

      DateTime selectedDate = DateTime.now();
      final List<GameWithLogs> selectedGamesWithLogs = <GameWithLogs>[];
      if(logDates.isNotEmpty) {
        selectedDate = logDates.last;

        if(logDates.any((DateTime date) => date.isSameDate(selectedDate))) {
          for(final GameWithLogs gameWithLogs in gamesWithLogs) {
            final List<GameTimeLog> logs = gameWithLogs.timeLogs
                .where((GameTimeLog log) => log.dateTime.isSameDate(selectedDate))
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
      }

      final int selectedTotalTimeSeconds = selectedGamesWithLogs.fold(0, (int previousSeconds, GameWithLogs gameWithLogs) => previousSeconds + gameWithLogs.totalTimeSeconds);
      final Duration selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);

      yield MultiCalendarLoaded(
        gamesWithLogs,
        logDates,
        selectedDate,
        selectedDate,
        selectedGamesWithLogs,
        selectedTotalTime,
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
      final List<GameWithLogs> selectedGamesWithLogs = (state as MultiCalendarLoaded).selectedGamesWithLogs;
      final Duration selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;

      final DateTime focusedDate = DateTime(year, DateTime.december, 1);

      final List<GameWithLogs> yearGamesWithLogs = await getReadAllGameWithTimeLogsInYearStream(year).first;

      for(final GameWithLogs yearGameWithLogs in yearGamesWithLogs) {
        try {
          final GameWithLogs gameWithLogs = gamesWithLogs.singleWhere((GameWithLogs tempGameWithLogs) => tempGameWithLogs.game.id == yearGameWithLogs.game.id);
          gameWithLogs.timeLogs.addAll(yearGameWithLogs.timeLogs);
        } catch(IterableElementError) {
          gamesWithLogs.add(yearGameWithLogs);
        }
      }

      final Set<DateTime> yearLogDates = yearGamesWithLogs.fold(SplayTreeSet<DateTime>(), (Set<DateTime> previousDates, GameWithLogs yearGameWithLogs) => previousDates..addAll(yearGameWithLogs.logDates));
      logDates.addAll(yearLogDates);

      yield MultiCalendarLoaded(
        gamesWithLogs,
        logDates,
        focusedDate,
        selectedDate,
        selectedGamesWithLogs,
        selectedTotalTime,
        style,
      );

    } catch (e) {

      yield CalendarNotLoaded(e.toString());

    }

  }

  Stream<CalendarState> _mapUpdateSelectedDateToState(UpdateSelectedDate event) async* {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = (state as MultiCalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final CalendarStyle style = (state as MultiCalendarLoaded).style;
      final List<GameWithLogs> selectedGamesWithLogs = <GameWithLogs>[];

      final DateTime selectedDate = event.date;

      if(logDates.isNotEmpty && logDates.any((DateTime date) => date.isSameDate(selectedDate))) {
        for(final GameWithLogs gameWithLogs in gamesWithLogs) {
          final List<GameTimeLog> logs = gameWithLogs.timeLogs.where((GameTimeLog log) => log.dateTime.isSameDate(selectedDate)).toList(growable: false);

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

      final int selectedTotalTimeSeconds = selectedGamesWithLogs.fold(0, (int previousSeconds, GameWithLogs gameWithLogs) => previousSeconds + gameWithLogs.totalTimeSeconds);
      final Duration selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);

      yield MultiCalendarLoaded(
        gamesWithLogs,
        logDates,
        selectedDate,
        selectedDate,
        selectedGamesWithLogs,
        selectedTotalTime,
        style,
      );
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

    if(state is MultiCalendarLoaded) {
      final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;

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

    /*if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gameWithLogs = (state as MultiCalendarLoaded).gamesWithLogs;
      final List<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
      final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
      final List<GameWithLogs> selectedGameWithLogs = (state as MultiCalendarLoaded).selectedGamesWithLogs;

      final rotatingIndex = ((state as MultiCalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      final List<TimeLog> selectedTimeLogs = _selectedTimeLogsInStyle(gameWithLogs, selectedDate, updatedStyle);

      yield MultiCalendarLoaded(
        gameWithLogs,
        logDates,
        selectedDate,
        selectedGameWithLogs,
        updatedStyle,
      );
    }*/

  }

  Stream<CalendarState> _mapUpdateToState(UpdateMultiCalendar event) async* {

    yield MultiCalendarLoaded(
      event.gamesWithLogs,
      event.logDates,
      event.focusedDate,
      event.selectedDate,
      event.selectedGamesWithLogs,
      event.selectedTotalTime,
      event.style,
    );

  }

  Stream<CalendarState> _mapUpdateListItemToState(UpdateCalendarListItem event) async* {

    if(state is MultiCalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = List<GameWithLogs>.from((state as MultiCalendarLoaded).gamesWithLogs);
      final List<GameWithLogs> selectedGamesWithLogs = List<GameWithLogs>.from((state as MultiCalendarLoaded).selectedGamesWithLogs);

      final int listItemIndex = gamesWithLogs.indexWhere((GameWithLogs item) => item.game.id == event.item.id);
      final int selectedListItemIndex = selectedGamesWithLogs.indexWhere((GameWithLogs item) => item.game.id == event.item.id);
      final GameWithLogs listItem = gamesWithLogs.elementAt(listItemIndex);

      if(listItem.game != event.item) {
        gamesWithLogs[listItemIndex] = GameWithLogs(game: event.item, timeLogs: listItem.timeLogs);

        if(selectedListItemIndex >= 0) {
          selectedGamesWithLogs[selectedListItemIndex] = gamesWithLogs[listItemIndex];
        }

        final Set<DateTime> logDates = (state as MultiCalendarLoaded).logDates;
        final DateTime focusedDate = (state as MultiCalendarLoaded).focusedDate;
        final DateTime selectedDate = (state as MultiCalendarLoaded).selectedDate;
        final Duration selectedTotalTime = (state as MultiCalendarLoaded).selectedTotalTime;
        final CalendarStyle style = (state as MultiCalendarLoaded).style;

        yield MultiCalendarLoaded(
          gamesWithLogs,
          logDates,
          focusedDate,
          selectedDate,
          selectedGamesWithLogs,
          selectedTotalTime,
          style,
        );
      }

    }

  }

  @override
  Future<void> close() {

    return super.close();

  }

  Stream<List<GameWithLogs>> getReadAllGameWithTimeLogsInYearStream(int year) {

    return iCollectionRepository.findAllGamesWithTimeLogsByYear(year);

  }
}