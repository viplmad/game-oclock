import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';


abstract class MultiCalendarState extends Equatable {
  const MultiCalendarState();

  @override
  List<Object> get props => [];
}

class CalendarLoading extends MultiCalendarState {}

class CalendarLoaded extends MultiCalendarState {
  const CalendarLoaded(this.gamesWithLogs, this.logDates, this.selectedDate, this.selectedGamesWithLogs, this.selectedTotalTime, [this.style = CalendarStyle.List]);

  final List<GameWithLogs> gamesWithLogs;
  final Set<DateTime> logDates;
  final DateTime selectedDate;
  final List<GameWithLogs> selectedGamesWithLogs;
  final Duration selectedTotalTime;
  final CalendarStyle style;

  @override
  List<Object> get props => [gamesWithLogs, logDates, selectedDate, style];

  @override
  String toString() => 'UpdateCalendar { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'selectedDate: $selectedDate, '
      'selectedLogs: $selectedGamesWithLogs, '
      'style: $style'
      ' }';
}

class CalendarNotLoaded extends MultiCalendarState {
  const CalendarNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CalendarNotLoaded { '
      'error: $error'
      ' }';
}