import 'package:backend/model/model.dart';
import 'package:backend/model/calendar_style.dart';

import 'calendar_event.dart';


abstract class SingleCalendarEvent extends CalendarEvent {
  const SingleCalendarEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadSingleCalendar extends SingleCalendarEvent {}

class UpdateSingleCalendar extends SingleCalendarEvent {
  // ignore: avoid_positional_boolean_parameters
  const UpdateSingleCalendar(this.timeLogs, this.logDates, this.finishDates, this.selectedDate, this.selectedTimeLogs, this.isSelectedDateFinish, this.selectedTotalTime, this.style);

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
  String toString() => 'UpdateSingleCalendar { '
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