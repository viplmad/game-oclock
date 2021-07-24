import 'package:backend/entity/entity.dart' show PlatformEntity;
import 'package:backend/model/model.dart' show Platform;


class PlatformMapper {
  PlatformMapper._();

  static PlatformEntity modelToEntity(Platform model) {

    return PlatformEntity(
      id: model.id,
      name: model.name,
      iconFilename: model.iconFilename,
      type: model.type,
    );

  }

  static Platform entityToModel(PlatformEntity entity, [String? iconURL]) {

    return Platform(
      id: entity.id,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
      type: entity.type,
    );

  }

  static Future<Platform> futureEntityToModel(Future<PlatformEntity> entityFuture, String? Function(String?) iconFunction) {

    return entityFuture.asStream().map( (PlatformEntity entity) {
      return entityToModel(entity, iconFunction(entity.iconFilename));
    }).first;

  }

  static Future<List<Platform>> futureEntityListToModelList(Future<List<PlatformEntity>> entityListFuture, String? Function(String?) iconFunction) {

    return entityListFuture.asStream().map( (List<PlatformEntity> entityList) {
      return entityList.map( (PlatformEntity entity) {
        return entityToModel(entity, iconFunction(entity.iconFilename));
      }).toList(growable: false);
    }).first;

  }
}