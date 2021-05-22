import 'package:backend/model/model.dart';
import 'package:backend/model/calendar_style.dart';

import 'calendar_event.dart';


abstract class MultiCalendarEvent extends CalendarEvent {
  const MultiCalendarEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadMultiCalendar extends MultiCalendarEvent {
  const LoadMultiCalendar(this.year);

  final int year;

  @override
  List<Object> get props => <Object>[year];

  @override
  String toString() => 'LoadMultiCalendar { '
      'year: $year'
      ' }';
}

class UpdateMultiCalendar extends MultiCalendarEvent {
  const UpdateMultiCalendar(this.gamesWithLogs, this.logDates, this.focusedDate, this.selectedDate, this.selectedGamesWithLogs, this.selectedTotalTime, this.style);

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
  String toString() => 'UpdateMultiCalendar { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedGameWithLogs: $selectedGamesWithLogs, '
      'selectedTotalTime: $selectedTotalTime, '
      'style: $style'
      ' }';
}

class UpdateCalendarListItem extends MultiCalendarEvent {
  const UpdateCalendarListItem(this.item);

  final Game item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'UpdateListItem { '
      'item: $item'
      ' }';
}