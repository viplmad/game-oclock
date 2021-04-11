import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';


abstract class MultiCalendarState extends Equatable {
  const MultiCalendarState();

  @override
  List<Object> get props => <Object>[];
}

class CalendarLoading extends MultiCalendarState {}

class CalendarLoaded extends MultiCalendarState {
  const CalendarLoaded(this.gamesWithLogs, this.logDates, this.focusedDate, this.selectedDate, this.selectedGamesWithLogs, this.selectedTotalTime, [this.style = CalendarStyle.List]);

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
  String toString() => 'CalendarLoaded { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedGameWithLogs: $selectedGamesWithLogs, '
      'selectedTotalTime: $selectedTotalTime, '
      'style: $style'
      ' }';
}

class CalendarNotLoaded extends MultiCalendarState {
  const CalendarNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'CalendarNotLoaded { '
      'error: $error'
      ' }';
}