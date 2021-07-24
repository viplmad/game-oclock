import 'package:backend/entity/entity.dart' show GameTagEntity;
import 'package:backend/model/model.dart' show Tag;


class GameTagMapper {
  GameTagMapper._();

  static GameTagEntity modelToEntity(Tag model) {

    return GameTagEntity(
      id: model.id,
      name: model.name,
    );

  }

  static Tag entityToModel(GameTagEntity entity) {

    return Tag(
      id: entity.id,
      name: entity.name,
    );

  }

  static Future<Tag> futureEntityToModel(Future<GameTagEntity> entityFuture) {

    return entityFuture.asStream().map( entityToModel ).first;

  }

  static Future<List<Tag>> futureEntityListToModelList(Future<List<GameTagEntity>> entityListFuture) {

    return entityListFuture.asStream().map( (List<GameTagEntity> entityList) {
      return entityList.map( entityToModel ).toList(growable: false);
    }).first;

  }
}