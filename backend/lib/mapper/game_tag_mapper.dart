import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


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
}