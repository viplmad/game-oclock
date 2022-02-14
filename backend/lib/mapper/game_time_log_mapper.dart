import 'package:backend/entity/entity.dart'
    show GameTimeLogEntity, GameWithLogsEntity;
import 'package:backend/model/model.dart' show GameTimeLog, GameWithLogs;

import 'mapper.dart' show GameMapper;

class GameTimeLogMapper {
  GameTimeLogMapper._();

  static GameTimeLogEntity modelToEntity(int gameId, GameTimeLog model) {
    return GameTimeLogEntity(
      gameId: gameId,
      dateTime: model.dateTime,
      time: model.time,
    );
  }

  static GameTimeLog entityToModel(GameTimeLogEntity entity) {
    return GameTimeLog(
      dateTime: entity.dateTime,
      time: entity.time,
    );
  }

  static Future<GameTimeLog> futureEntityToModel(
    Future<GameTimeLogEntity> entityFuture,
  ) {
    return entityFuture.asStream().map(entityToModel).first;
  }

  static Future<List<GameTimeLog>> futureEntityListToModelList(
    Future<List<GameTimeLogEntity>> entityListFuture,
  ) {
    return entityListFuture
        .asStream()
        .map((List<GameTimeLogEntity> entityList) {
      return entityList.map(entityToModel).toList(growable: false);
    }).first;
  }

  static GameWithLogsEntity gameWithLogModelToEntity(GameWithLogs model) {
    return GameWithLogsEntity(
      game: GameMapper.modelToEntity(model.game),
      timeLogs: model.timeLogs
          .map<GameTimeLogEntity>(
            (GameTimeLog entity) => modelToEntity(model.game.id, entity),
          )
          .toList(growable: false),
    );
  }

  static GameWithLogs gameWithLogEntityToModel(
    GameWithLogsEntity entity, [
    String? coverURL,
  ]) {
    return GameWithLogs(
      game: GameMapper.entityToModel(entity.game, coverURL),
      timeLogs: entity.timeLogs.map<GameTimeLog>(entityToModel).toList(),
    );
  }

  static Future<List<GameWithLogs>> futureGameWithLogEntityListToModelList(
    Future<List<GameWithLogsEntity>> entityListFuture,
    String? Function(String?) coverFunction,
  ) {
    return entityListFuture
        .asStream()
        .map((List<GameWithLogsEntity> entityList) {
      return entityList.map((GameWithLogsEntity entity) {
        return gameWithLogEntityToModel(
          entity,
          coverFunction(entity.game.coverFilename),
        );
      }).toList(growable: false);
    }).first;
  }
}
