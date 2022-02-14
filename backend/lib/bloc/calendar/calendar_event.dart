import 'package:equatable/equatable.dart';

import 'package:backend/model/calendar_range.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => <Object>[];
}

class UpdateSelectedDate extends CalendarEvent {
  const UpdateSelectedDate(this.date);

  final DateTime date;

  @override
  List<Object> get props => <Object>[date];

  @override
  String toString() => 'UpdateSelectedDate { '
      'date: $date'
      ' }';
}

class UpdateSelectedDateFirst extends CalendarEvent {}

class UpdateSelectedDateLast extends CalendarEvent {}

class UpdateSelectedDatePrevious extends CalendarEvent {}

class UpdateSelectedDateNext extends CalendarEvent {}

class UpdateCalendarRange extends CalendarEvent {
  const UpdateCalendarRange(this.range);

  final CalendarRange range;

  @override
  List<Object> get props => <Object>[range];

  @override
  String toString() => 'UpdateCalendarRange { '
      'range: $range'
      ' }';
}

class UpdateCalendarStyle extends CalendarEvent {}
