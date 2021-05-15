import 'package:equatable/equatable.dart';

import 'package:game_collection/utils/datetime_extension.dart';

import 'package:game_collection/entity/entity.dart';

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

  static GameWithLogs fromEntity(GameWithLogsEntity entity, [String? coverURL]) {

    return GameWithLogs(
      game: Game.fromEntity(entity.game, coverURL),
      timeLogs: entity.timeLogs.map<GameTimeLog>( GameTimeLog.fromEntity ).toList(),
    );

  }

  GameWithLogsEntity toEntity() {

    return GameWithLogsEntity(
      game: this.game.toEntity(),
      timeLogs: this.timeLogs.map<GameTimeLogEntity>((GameTimeLog log) => log.toEntity()).toList(growable: false),
    );

  }

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