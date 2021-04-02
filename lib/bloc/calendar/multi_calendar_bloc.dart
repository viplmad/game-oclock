import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';

import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'multi_calendar.dart';


class MultiCalendarBloc extends Bloc<MultiCalendarEvent, MultiCalendarState> {
  MultiCalendarBloc({
    required this.iCollectionRepository,
  }) : super(CalendarLoading());

  final ICollectionRepository iCollectionRepository;

  @override
  Stream<MultiCalendarState> mapEventToState(MultiCalendarEvent event) async* {

    yield* _checkConnection();

    if(event is LoadCalendar) {

      yield* _mapLoadToState(event);

    } else if(event is UpdateSelectedDate) {

      yield* _mapUpdateSelectedDateToState(event);

    } else if(event is UpdateStyle) {

      yield* _mapUpdateStyleToState(event);

    } else if(event is UpdateSelectedDateFirst) {

      yield* _mapUpdateSelectedDateFirstToState(event);

    } else if(event is UpdateSelectedDateLast) {

      yield* _mapUpdateSelectedDateLastToState(event);

    } else if(event is UpdateSelectedDatePrevious) {

      yield* _mapUpdateSelectedDatePreviousToState(event);

    } else if(event is UpdateSelectedDateNext) {

      yield* _mapUpdateSelectedDateNextToState(event);

    } else if(event is UpdateCalendar) {

      yield* _mapUpdateToState(event);

    }

  }

  Stream<MultiCalendarState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield CalendarNotLoaded('Connection lost. Trying to reconnect');

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<MultiCalendarState> _mapLoadToState(LoadCalendar event) async* {

    yield CalendarLoading();

    try {

      final List<GameWithLogs> gamesWithLogs = await getReadAllGameWithTimeLogsInYearStream(event.year).first;
      final Set<DateTime> logDates = gamesWithLogs.fold(SplayTreeSet<DateTime>(), (Set<DateTime> previousDates, GameWithLogs gameWithLogs) => previousDates..addAll(gameWithLogs.logDates));

      DateTime selectedDate = DateTime.now();
      List<GameWithLogs> selectedGamesWithLogs = <GameWithLogs>[];
      if(logDates.isNotEmpty) {
        selectedDate = logDates.last;

        if(logDates.any((DateTime date) => date.isSameDate(selectedDate))) {
          for(GameWithLogs gameWithLogs in gamesWithLogs) {
            final List<TimeLog> logs = gameWithLogs.timeLogs.where((TimeLog log) => log.dateTime.isSameDate(selectedDate)).toList(growable: false);

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

      int selectedTotalTimeSeconds = selectedGamesWithLogs.fold(0, (int previousSeconds, GameWithLogs gameWithLogs) => previousSeconds + gameWithLogs.totalTimeSeconds());
      Duration selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);

      yield CalendarLoaded(
        gamesWithLogs,
        logDates,
        selectedDate,
        selectedGamesWithLogs,
        selectedTotalTime,
      );

    } catch (e) {

      yield CalendarNotLoaded(e.toString());

    }

  }

  Stream<MultiCalendarState> _mapUpdateSelectedDateToState(UpdateSelectedDate event) async* {

    if(state is CalendarLoaded) {
      final List<GameWithLogs> gamesWithLogs = (state as CalendarLoaded).gamesWithLogs;
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final CalendarStyle style = (state as CalendarLoaded).style;
      //final DateTime previousSelectedDate = (state as CalendarLoaded).selectedDate;
      List<GameWithLogs> selectedGamesWithLogs = <GameWithLogs>[];

      final DateTime selectedDate = event.date;

      /*if((style == CalendarStyle.List) || (style == CalendarStyle.Graph && !event.date.isInWeekOf(previousSelectedDate))) {
        selectedTimeLogs = _selectedTimeLogsInStyle(timeLogs, event.date, style);
      }*/

      if(logDates.isNotEmpty && logDates.any((DateTime date) => date.isSameDate(selectedDate))) {
        for(GameWithLogs gameWithLogs in gamesWithLogs) {
          final List<TimeLog> logs = gameWithLogs.timeLogs.where((TimeLog log) => log.dateTime.isSameDate(selectedDate)).toList(growable: false);

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

      int selectedTotalTimeSeconds = selectedGamesWithLogs.fold(0, (int previousSeconds, GameWithLogs gameWithLogs) => previousSeconds + gameWithLogs.totalTimeSeconds());
      Duration selectedTotalTime = Duration(seconds: selectedTotalTimeSeconds);

      yield CalendarLoaded(
        gamesWithLogs,
        logDates,
        selectedDate,
        selectedGamesWithLogs,
        selectedTotalTime,
        style,
      );
    }

  }

  Stream<MultiCalendarState> _mapUpdateSelectedDateFirstToState(UpdateSelectedDateFirst event) async* {

    if(state is CalendarLoaded) {
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        DateTime firstDate = logDates.first;

        add(UpdateSelectedDate(firstDate));
      }
    }

  }

  Stream<MultiCalendarState> _mapUpdateSelectedDateLastToState(UpdateSelectedDateLast event) async* {

    if(state is CalendarLoaded) {
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;

      if(logDates.isNotEmpty) {
        DateTime lastDate = logDates.last;

        add(UpdateSelectedDate(lastDate));
      }
    }

  }

  Stream<MultiCalendarState> _mapUpdateSelectedDatePreviousToState(UpdateSelectedDatePrevious event) async* {

    if(state is CalendarLoaded) {
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;

      DateTime? previousDate;
      if(logDates.isNotEmpty) {
        List<DateTime> listLogDates = logDates.toList(growable: false);
        int selectedIndex = listLogDates.indexWhere((DateTime date) => date.isSameDate(selectedDate));
        selectedIndex = (selectedIndex.isNegative)? listLogDates.length : selectedIndex;

        for(int index = selectedIndex - 1; index >= 0 && previousDate == null; index--) {
          DateTime date = listLogDates.elementAt(index);

          if(date.isBefore(selectedDate)) {
            previousDate = date;
          }
        }
      }

      add(UpdateSelectedDate(previousDate?? selectedDate));
    }

  }

  Stream<MultiCalendarState> _mapUpdateSelectedDateNextToState(UpdateSelectedDateNext event) async* {

    if(state is CalendarLoaded) {
      final Set<DateTime> logDates = (state as CalendarLoaded).logDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;

      DateTime? nextDate;
      if(logDates.isNotEmpty) {
        List<DateTime> listLogDates = logDates.toList(growable: false);
        int selectedIndex = listLogDates.indexWhere((DateTime date) => date.isSameDate(selectedDate));
        selectedIndex = (selectedIndex.isNegative)? 0 : selectedIndex;

        for(int index = selectedIndex + 1; index < listLogDates.length && nextDate == null; index++) {
          DateTime date = listLogDates.elementAt(index);

          if(date.isAfter(selectedDate)) {
            nextDate = date;
          }
        }
      }

      add(UpdateSelectedDate(nextDate?? selectedDate));
    }

  }

  Stream<MultiCalendarState> _mapUpdateStyleToState(UpdateStyle event) async* {

    /*if(state is CalendarLoaded) {
      final List<GameWithLogs> gameWithLogs = (state as CalendarLoaded).gamesWithLogs;
      final List<DateTime> logDates = (state as CalendarLoaded).logDates;
      final DateTime selectedDate = (state as CalendarLoaded).selectedDate;
      final List<GameWithLogs> selectedGameWithLogs = (state as CalendarLoaded).selectedGamesWithLogs;

      final rotatingIndex = ((state as CalendarLoaded).style.index + 1) % CalendarStyle.values.length;
      final CalendarStyle updatedStyle = CalendarStyle.values.elementAt(rotatingIndex);

      final List<TimeLog> selectedTimeLogs = _selectedTimeLogsInStyle(gameWithLogs, selectedDate, updatedStyle);

      yield CalendarLoaded(
        gameWithLogs,
        logDates,
        selectedDate,
        selectedGameWithLogs,
        updatedStyle,
      );
    }*/

  }

  Stream<MultiCalendarState> _mapUpdateToState(UpdateCalendar event) async* {

    yield CalendarLoaded(
      event.gamesWithLogs,
      event.logDates,
      event.selectedDate,
      event.selectedGamesWithLogs,
      event.selectedTotalTime,
      event.style,
    );

  }

  /*List<TimeLog> _selectedTimeLogsInStyle(List<TimeLog> timeLogs, DateTime selectedDate, CalendarStyle style) {
    List<TimeLog> selectedTimeLogs = <TimeLog>[];

    switch(style) {
      case CalendarStyle.List:
        selectedTimeLogs = timeLogs
            .where((TimeLog log) => log.dateTime.isSameDate(selectedDate))
            .toList(growable: false);
        break;
      case CalendarStyle.Graph:
        DateTime mondayOfSelectedDate = selectedDate.getMondayOfWeek();

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

    return selectedTimeLogs..sort();
  }*/

  @override
  Future<void> close() {

    return super.close();

  }

  Stream<List<GameWithLogs>> getReadAllGameWithTimeLogsInYearStream(int year) {

    return iCollectionRepository.getGamesWithTimeLogsWithYear(year);

  }
}