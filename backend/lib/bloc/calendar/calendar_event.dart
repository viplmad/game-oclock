import 'package:equatable/equatable.dart';


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

class UpdateCalendarStyle extends CalendarEvent {}