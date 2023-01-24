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
