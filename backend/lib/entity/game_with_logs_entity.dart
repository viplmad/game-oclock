import 'package:equatable/equatable.dart';

import 'entity.dart' show GameEntity, GameTimeLogEntity;


class GameWithLogsEntity extends Equatable {
  GameWithLogsEntity({
    required this.game,
    List<GameTimeLogEntity>? timeLogs,
  }) {

    this.timeLogs = timeLogs?? <GameTimeLogEntity>[];

  }

  final GameEntity game;
  late final List<GameTimeLogEntity> timeLogs;

  void addTimeLog(GameTimeLogEntity timeLog) {
    timeLogs.add(timeLog);
  }

  @override
  List<Object> get props => <Object>[
    game,
    timeLogs,
  ];

  @override
  String toString() {

    return 'GameWithLogsEntity { '
        'Game: $game, '
        'TimeLogs: $timeLogs'
        ' }';

  }
}