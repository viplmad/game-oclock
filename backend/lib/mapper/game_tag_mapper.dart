import 'package:backend/entity/entity.dart' show GameTagEntity;
import 'package:backend/model/model.dart' show GameTag;


class GameTagMapper {
  GameTagMapper._();

  static GameTagEntity modelToEntity(GameTag model) {

    return GameTagEntity(
      id: model.id,
      name: model.name,
    );

  }

  static GameTag entityToModel(GameTagEntity entity) {

    return GameTag(
      id: entity.id,
      name: entity.name,
    );

  }

  static Future<GameTag> futureEntityToModel(Future<GameTagEntity> entityFuture) {

    return entityFuture.asStream().map( entityToModel ).first;

  }

  static Future<List<GameTag>> futureEntityListToModelList(Future<List<GameTagEntity>> entityListFuture) {

    return entityListFuture.asStream().map( (List<GameTagEntity> entityList) {
      return entityList.map( entityToModel ).toList(growable: false);
    }).first;

  }
}