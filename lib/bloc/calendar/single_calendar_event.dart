import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/calendar_style.dart';


abstract class SingleCalendarEvent extends Equatable {
  const SingleCalendarEvent();

  @override
  List<Object> get props => [];
}

class LoadCalendar extends SingleCalendarEvent {}

class UpdateCalendar extends SingleCalendarEvent {
  const UpdateCalendar(this.timeLogs, this.finishDates, this.selectedDate, this.selectedTimeLogs, this.isSelectedDateFinish, this.style);

  final List<TimeLog> timeLogs;
  final List<DateTime> finishDates;
  final DateTime selectedDate;
  final List<TimeLog> selectedTimeLogs;
  final bool isSelectedDateFinish;
  final CalendarStyle style;

  @override
  List<Object> get props => [timeLogs, finishDates, selectedDate, style];

  @override
  String toString() => 'UpdateCalendar { '
      'timeLogs: $timeLogs, '
      'finishDates: $finishDates, '
      'selectedDate: $selectedDate, '
      'selectedTimeLogs: $selectedTimeLogs, '
      'isSelectedDateFinish: $isSelectedDateFinish, '
      'style: $style'
      ' }';
}

class UpdateSelectedDate extends SingleCalendarEvent {
  const UpdateSelectedDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'UpdateSelectedDate { '
      'date: $date'
      ' }';
}

class UpdateSelectedDateFirst extends SingleCalendarEvent {}

class UpdateSelectedDateLast extends SingleCalendarEvent {}

class UpdateSelectedDatePrevious extends SingleCalendarEvent {}

class UpdateSelectedDateNext extends SingleCalendarEvent {}

class UpdateStyle extends SingleCalendarEvent {}