import 'package:game_collection_client/api.dart' show GameDTO;

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

class UpdateCalendarListItem extends MultiCalendarEvent {
  const UpdateCalendarListItem(this.item);

  final GameDTO item;

  @override
  List<Object> get props => <Object>[item];

  @override
  String toString() => 'UpdateListItem { '
      'item: $item'
      ' }';
}
