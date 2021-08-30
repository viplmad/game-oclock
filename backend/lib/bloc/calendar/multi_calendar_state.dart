import 'package:backend/model/model.dart';
import 'package:backend/model/calendar_range.dart';
import 'package:backend/model/calendar_style.dart';

import 'calendar_state.dart';


abstract class MultiCalendarState extends CalendarState {
  const MultiCalendarState();

  @override
  List<Object> get props => <Object>[];
}

abstract class MultiCalendarLoaded extends MultiCalendarState {
  const MultiCalendarLoaded(this.gamesWithLogs, this.logDates, this.focusedDate, this.selectedDate, this.selectedTotalTime, this.range, [this.style = CalendarStyle.List]);

  final List<GameWithLogs> gamesWithLogs;
  final Set<DateTime> logDates;
  final DateTime focusedDate;
  final DateTime selectedDate;
  final Duration selectedTotalTime;
  final CalendarRange range;
  final CalendarStyle style;

  @override
  List<Object> get props => <Object>[gamesWithLogs, logDates, focusedDate, selectedDate, range, style];

  @override
  String toString() => 'MultiCalendarLoaded { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedTotalTime: $selectedTotalTime, '
      'range: $range, '
      'style: $style'
      ' }';
}

class MultiCalendarListLoaded extends MultiCalendarLoaded {
  const MultiCalendarListLoaded(List<GameWithLogs> gamesWithLogs, Set<DateTime> logDates, DateTime focusedDate, DateTime selectedDate, this.selectedGamesWithLogs, Duration selectedTotalTime, CalendarRange range) : super(gamesWithLogs, logDates, focusedDate, selectedDate, selectedTotalTime, range, CalendarStyle.List);

  final List<GameWithLogs> selectedGamesWithLogs;

  @override
  String toString() => 'MultiCalendarLoaded { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedGameWithLogs: $selectedGamesWithLogs, '
      'selectedTotalTime: $selectedTotalTime, '
      'range: $range, '
      'style: $style'
      ' }';
}

class MultiCalendarGraphLoaded extends MultiCalendarLoaded {
  const MultiCalendarGraphLoaded(List<GameWithLogs> gamesWithLogs, Set<DateTime> logDates, DateTime focusedDate, DateTime selectedDate, this.selectedTimeLogs, Duration selectedTotalTime, CalendarRange range) : super(gamesWithLogs, logDates, focusedDate, selectedDate, selectedTotalTime, range, CalendarStyle.Graph);

  final List<GameTimeLog> selectedTimeLogs;

  @override
  String toString() => 'MultiCalendarLoaded { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedTimeLogs: $selectedTimeLogs, '
      'selectedTotalTime: $selectedTotalTime, '
      'range: $range, '
      'style: $style'
      ' }';
}