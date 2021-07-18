import 'package:equatable/equatable.dart';

import 'entity.dart';


// ignore: must_be_immutable
class GameWithLogsEntity extends Equatable {
  GameWithLogsEntity({
    required this.game,
    List<GameTimeLogEntity>? timeLogs,
  }) {

    this.timeLogs = timeLogs?? <GameTimeLogEntity>[];

  }

  final GameEntity game;
  late List<GameTimeLogEntity> timeLogs;

  void addTimeLog(GameTimeLogEntity timeLog) {
    timeLogs.add(timeLog);
  }

  static List<GameWithLogsEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameWithLogsEntity> gamesWithLogsList = <GameWithLogsEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {

      final Map<String, dynamic> gameMap = manyMap[GameTimeLogEntityData.table]!;
      final GameEntity gameEntity = GameEntity.fromDynamicMap(gameMap);

      final Map<String, dynamic> timeLogMap = ItemEntity.combineMaps(manyMap, GameTimeLogEntityData.table);
      final GameTimeLogEntity timeLogEntity = GameTimeLogEntity.fromDynamicMap(timeLogMap);

      GameWithLogsEntity gameWithLogs;
      try {
        gameWithLogs = gamesWithLogsList.singleWhere((GameWithLogsEntity tempGameWithLogs) => tempGameWithLogs.game.id == gameEntity.id);
      } catch(IterableElementError) {
        gameWithLogs = GameWithLogsEntity(game: gameEntity);
        gamesWithLogsList.add(gameWithLogs);
      }

      gameWithLogs.addTimeLog(timeLogEntity);

    });

    return gamesWithLogsList;

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