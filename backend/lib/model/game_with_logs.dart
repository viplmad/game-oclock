import 'package:equatable/equatable.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'model.dart' show Game, GameTimeLog;


class GameWithLogs extends Equatable implements Comparable<GameWithLogs> {
  GameWithLogs({
    required this.game,
    required this.timeLogs,
  });

  final Game game;
  final List<GameTimeLog> timeLogs;

  Set<DateTime> get logDates => timeLogs.map<DateTime>((GameTimeLog log) => log.dateTime.toDate()).toSet();

  Duration get totalTime => timeLogs.fold<Duration>(const Duration(), (Duration previousDuration, GameTimeLog log) => previousDuration + log.time);

  @override
  List<Object> get props => <Object>[
    game,
    timeLogs,
  ];

  @override
  String toString() {

    return 'GameWithLogs { '
        'Game: $game, '
        'Time Logs: $timeLogs'
        ' }';

  }

  @override
  int compareTo(GameWithLogs other) => other.totalTime.compareTo(this.totalTime); // Longer total time first
}