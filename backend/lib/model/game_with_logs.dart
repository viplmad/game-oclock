import 'package:equatable/equatable.dart';

import 'package:backend/utils/datetime_extension.dart';

import 'model.dart';


// ignore: must_be_immutable
class GameWithLogs extends Equatable {
  GameWithLogs({
    required this.game,
    required this.timeLogs,
  });

  final Game game;
  final List<GameTimeLog> timeLogs;

  Set<DateTime> get logDates => timeLogs.map<DateTime>((GameTimeLog log) => log.dateTime.toDate()).toSet();

  int get totalTimeSeconds => timeLogs.fold<int>(0, (int previousSeconds, GameTimeLog log) => previousSeconds + log.time.inSeconds);

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
}