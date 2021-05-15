import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';


abstract class SingleCalendarState extends Equatable {
  const SingleCalendarState();

  @override
  List<Object> get props => <Object>[];
}

class CalendarLoading extends SingleCalendarState {}

class CalendarLoaded extends SingleCalendarState {
  // ignore: avoid_positional_boolean_parameters
  const CalendarLoaded(this.timeLogs, this.logDates, this.finishDates, this.selectedDate, this.selectedTimeLogs, this.isSelectedDateFinish, this.selectedTotalTime, [this.style = CalendarStyle.List]);

  final List<GameTimeLog> timeLogs;
  final Set<DateTime> logDates;
  final List<GameFinish> finishDates;
  final DateTime selectedDate;
  final List<GameTimeLog> selectedTimeLogs;
  final bool isSelectedDateFinish;
  final Duration selectedTotalTime;
  final CalendarStyle style;

  @override
  List<Object> get props => <Object>[timeLogs, logDates, finishDates, selectedDate, style];

  @override
  String toString() => 'CalendarLoaded { '
      'timeLogs: $timeLogs, '
      'logDates: $logDates, '
      'finishDates: $finishDates, '
      'selectedDate: $selectedDate, '
      'selectedTimeLogs: $selectedTimeLogs, '
      'isSelectedDateFinish: $isSelectedDateFinish, '
      'selectedTotalTime: $selectedTotalTime, '
      'style: $style'
      ' }';
}

class CalendarNotLoaded extends SingleCalendarState {
  const CalendarNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => <Object>[error];

  @override
  String toString() => 'CalendarNotLoaded { '
      'error: $error'
      ' }';
}