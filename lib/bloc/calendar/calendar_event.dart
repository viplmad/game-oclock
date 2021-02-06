import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class LoadCalendar extends CalendarEvent {}

class UpdateCalendar extends CalendarEvent {
  const UpdateCalendar(this.timeLogs, this.finishDates, this.selectedDate, this.selectedTimeLogs);

  final List<TimeLog> timeLogs;
  final List<DateTime> finishDates;
  final DateTime selectedDate;
  final List<TimeLog> selectedTimeLogs;

  @override
  List<Object> get props => [timeLogs, finishDates, selectedDate];

  @override
  String toString() => 'UpdateCalendar { '
      'timeLogs: $timeLogs, '
      'finishDates: $finishDates, '
      'selectedDate: $selectedDate, '
      'selectedTimeLogs: $selectedTimeLogs'
      ' }';
}

class UpdateSelectedDate extends CalendarEvent {
  const UpdateSelectedDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'UpdateSelectedDate { '
      'date: $date'
      ' }';
}