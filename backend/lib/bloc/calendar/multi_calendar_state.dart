import 'package:backend/model/model.dart';
import 'package:backend/model/calendar_style.dart';

import 'calendar_state.dart';


abstract class MultiCalendarState extends CalendarState {
  const MultiCalendarState();

  @override
  List<Object> get props => <Object>[];
}

class MultiCalendarLoaded extends MultiCalendarState {
  const MultiCalendarLoaded(this.gamesWithLogs, this.logDates, this.focusedDate, this.selectedDate, this.selectedGamesWithLogs, this.selectedTotalTime, [this.style = CalendarStyle.List]);

  final List<GameWithLogs> gamesWithLogs;
  final Set<DateTime> logDates;
  final DateTime focusedDate;
  final DateTime selectedDate;
  final List<GameWithLogs> selectedGamesWithLogs;
  final Duration selectedTotalTime;
  final CalendarStyle style;

  @override
  List<Object> get props => <Object>[gamesWithLogs, logDates, focusedDate, selectedDate, style];

  @override
  String toString() => 'MultiCalendarLoaded { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedGameWithLogs: $selectedGamesWithLogs, '
      'selectedTotalTime: $selectedTotalTime, '
      'style: $style'
      ' }';
}