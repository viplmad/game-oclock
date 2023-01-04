import 'package:game_collection_client/api.dart'
    show GameWithLogsDTO, GameLogDTO;

import 'package:backend/model/model.dart' show CalendarRange, CalendarStyle;

import 'calendar_state.dart';

abstract class MultiCalendarState extends CalendarState {
  const MultiCalendarState();

  @override
  List<Object> get props => <Object>[];
}

class MultiCalendarLoaded extends MultiCalendarState {
  const MultiCalendarLoaded(
    this.gamesWithLogs,
    this.logDates,
    this.focusedDate,
    this.selectedDate,
    this.selectedGamesWithLogs,
    this.selectedTotalTime,
    this.range, [
    this.style = CalendarStyle.list,
  ]);

  final List<GameWithLogsDTO> gamesWithLogs;
  final Set<DateTime> logDates;
  final DateTime focusedDate;
  final DateTime selectedDate;
  final List<GameWithLogsDTO> selectedGamesWithLogs;
  final Duration selectedTotalTime;
  int get selectedTotalGames => selectedGamesWithLogs.length;
  final CalendarRange range;
  final CalendarStyle style;

  @override
  List<Object> get props => <Object>[
        gamesWithLogs,
        logDates,
        focusedDate,
        selectedDate,
        range,
        style
      ];

  @override
  String toString() => 'MultiCalendarLoaded { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedGameWithLogs: $selectedGamesWithLogs, '
      'selectedTotalTime: $selectedTotalTime, '
      'range: $range, '
      'style: $style'
      ' }';
}

class MultiCalendarGraphLoaded extends MultiCalendarLoaded {
  const MultiCalendarGraphLoaded(
    List<GameWithLogsDTO> gamesWithLogs,
    Set<DateTime> logDates,
    DateTime focusedDate,
    DateTime selectedDate,
    List<GameWithLogsDTO> selectedGamesWithLogs,
    this.selectedGameLogs,
    Duration selectedTotalTime,
    CalendarRange range,
  ) : super(
          gamesWithLogs,
          logDates,
          focusedDate,
          selectedDate,
          selectedGamesWithLogs,
          selectedTotalTime,
          range,
          CalendarStyle.graph,
        );

  final List<GameLogDTO> selectedGameLogs;

  @override
  String toString() => 'MultiCalendarLoaded { '
      'gamesWithLogs: $gamesWithLogs, '
      'logDates: $logDates, '
      'focusedDate: $focusedDate, '
      'selectedDate: $selectedDate, '
      'selectedGameLogs: $selectedGameLogs, '
      'selectedTotalTime: $selectedTotalTime, '
      'range: $range, '
      'style: $style'
      ' }';
}
