import 'package:backend/model/model.dart';
import 'package:backend/model/calendar_range.dart';
import 'package:backend/model/calendar_style.dart';

import 'calendar_event.dart';

abstract class SingleCalendarEvent extends CalendarEvent {
  const SingleCalendarEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadSingleCalendar extends SingleCalendarEvent {}

class UpdateSingleCalendar extends SingleCalendarEvent {
  const UpdateSingleCalendar(
    this.timeLogs,
    this.logDates,
    this.finishDates,
    this.selectedDate,
    this.selectedTimeLogs,
    // ignore: avoid_positional_boolean_parameters
    this.isSelectedDateFinish,
    this.selectedTotalTime,
    this.range,
    this.style,
  );

  final List<GameTimeLog> timeLogs;
  final Set<DateTime> logDates;
  final List<GameFinish> finishDates;
  final DateTime selectedDate;
  final List<GameTimeLog> selectedTimeLogs;
  final bool isSelectedDateFinish;
  final Duration selectedTotalTime;
  final CalendarRange range;
  final CalendarStyle style;

  @override
  List<Object> get props =>
      <Object>[timeLogs, logDates, finishDates, selectedDate, range, style];

  @override
  String toString() => 'UpdateSingleCalendar { '
      'timeLogs: $timeLogs, '
      'logDates: $logDates, '
      'finishDates: $finishDates, '
      'selectedDate: $selectedDate, '
      'selectedTimeLogs: $selectedTimeLogs, '
      'isSelectedDateFinish: $isSelectedDateFinish, '
      'selectedTotalTime: $selectedTotalTime, '
      'range: $range, '
      'style: $style'
      ' }';
}
