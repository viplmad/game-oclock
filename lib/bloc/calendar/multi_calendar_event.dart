import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';


abstract class MultiCalendarEvent extends Equatable {
  const MultiCalendarEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadCalendar extends MultiCalendarEvent {
  const LoadCalendar(this.year);

  final int year;

  @override
  List<Object> get props => <Object>[year];

  @override
  String toString() => 'LoadCalendar { '
      'year: $year'
      ' }';
}

class UpdateCalendar extends MultiCalendarEvent {
  const UpdateCalendar(this.gamesWithLogs, this.logDates, this.focusedDate, this.selectedDate, this.selectedGamesWithLogs, this.selectedTotalTime, this.style);

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
  String toString() => 'UpdateCalendar { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedGameWithLogs: $selectedGamesWithLogs, '
      'selectedTotalTime: $selectedTotalTime, '
      'style: $style'
      ' }';
}

class UpdateSelectedDate extends MultiCalendarEvent {
  const UpdateSelectedDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => <Object>[date];

  @override
  String toString() => 'UpdateSelectedDate { '
      'date: $date'
      ' }';
}

class UpdateSelectedDateFirst extends MultiCalendarEvent {}

class UpdateSelectedDateLast extends MultiCalendarEvent {}

class UpdateSelectedDatePrevious extends MultiCalendarEvent {}

class UpdateSelectedDateNext extends MultiCalendarEvent {}

class UpdateStyle extends MultiCalendarEvent {}

class UpdateListItem extends MultiCalendarEvent {
  const UpdateListItem(this.item);

  final Game item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'UpdateListItem { '
      'item: $item'
      ' }';
}