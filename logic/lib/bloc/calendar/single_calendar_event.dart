import 'package:game_collection_client/api.dart' show GameLogDTO;

import 'package:logic/model/model.dart' show CalendarRange, CalendarStyle;

import 'calendar_event.dart';

abstract class SingleCalendarEvent extends CalendarEvent {
  const SingleCalendarEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadSingleCalendar extends SingleCalendarEvent {}

class ReloadSingleCalendar extends SingleCalendarEvent {}

class UpdateSingleCalendar extends SingleCalendarEvent {
  const UpdateSingleCalendar(
    this.gameLogs,
    this.logDates,
    this.finishDates,
    this.selectedDate,
    this.selectedGameLogs,
    // ignore: avoid_positional_boolean_parameters
    this.isSelectedDateFinish,
    this.selectedTotalTime,
    this.range,
    this.style,
  );

  final List<GameLogDTO> gameLogs;
  final Set<DateTime> logDates;
  final List<DateTime> finishDates;
  final DateTime selectedDate;
  final List<GameLogDTO> selectedGameLogs;
  final bool isSelectedDateFinish;
  final Duration selectedTotalTime;
  final CalendarRange range;
  final CalendarStyle style;

  @override
  List<Object> get props =>
      <Object>[gameLogs, logDates, finishDates, selectedDate, range, style];

  @override
  String toString() => 'UpdateSingleCalendar { '
      'gameLogs: $gameLogs, '
      'logDates: $logDates, '
      'finishDates: $finishDates, '
      'selectedDate: $selectedDate, '
      'selectedGameLogs: $selectedGameLogs, '
      'isSelectedDateFinish: $isSelectedDateFinish, '
      'selectedTotalTime: $selectedTotalTime, '
      'range: $range, '
      'style: $style'
      ' }';
}
