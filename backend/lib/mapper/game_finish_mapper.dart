import 'package:backend/entity/entity.dart' show GameFinishEntity;
import 'package:backend/model/model.dart' show GameFinish;

class GameFinishMapper {
  GameFinishMapper._();

  static GameFinishEntity modelToEntity(int gameId, GameFinish model) {
    return GameFinishEntity(
      gameId: gameId,
      dateTime: model.dateTime,
    );
  }

  static GameFinish entityToModel(GameFinishEntity entity) {
    return GameFinish(
      dateTime: entity.dateTime,
    );
  }

  static Future<GameFinish> futureEntityToModel(
    Future<GameFinishEntity> entityFuture,
  ) {
    return entityFuture.asStream().map(entityToModel).first;
  }

  static Future<List<GameFinish>> futureEntityListToModelList(
    Future<List<GameFinishEntity>> entityListFuture,
  ) {
    return entityListFuture.asStream().map((List<GameFinishEntity> entityList) {
      return entityList.map(entityToModel).toList(growable: false);
    }).first;
  }
}
