import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';


abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  const CalendarLoaded(this.timeLogs, this.finishDates, this.selectedDate, this.selectedTimeLogs, this.isSelectedDateFinish, [this.style = CalendarStyle.List]);

  final List<TimeLog> timeLogs;
  final List<DateTime> finishDates;
  final DateTime selectedDate;
  final List<TimeLog> selectedTimeLogs;
  final bool isSelectedDateFinish;
  final CalendarStyle style;

  @override
  List<Object> get props => [timeLogs, finishDates, selectedDate, isSelectedDateFinish, style];

  @override
  String toString() => 'CalendarLoaded { '
      'timeLogs: $timeLogs, '
      'finishDates: $finishDates, '
      'selectedDate: $selectedDate, '
      'selectedTimeLogs: $selectedTimeLogs, '
      'isSelectedDateFinish: $isSelectedDateFinish, '
      'style: $style'
      ' }';
}

class CalendarNotLoaded extends CalendarState {
  const CalendarNotLoaded(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CalendarNotLoaded { '
      'error: $error'
      ' }';
}