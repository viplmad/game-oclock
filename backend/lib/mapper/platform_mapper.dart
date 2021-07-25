import 'package:backend/entity/entity.dart' show PlatformEntity, physicalValue, digitalValue;
import 'package:backend/model/model.dart' show Platform, PlatformType;


class PlatformMapper {
  PlatformMapper._();

  static const Map<PlatformType, String> typeToStringMap = <PlatformType, String> {
    PlatformType.Physical: physicalValue,
    PlatformType.Digital: digitalValue,
  };

  static const Map<String, PlatformType> stringToTypeMap = <String, PlatformType> {
    physicalValue: PlatformType.Physical,
    digitalValue: PlatformType.Digital,
  };

  static PlatformEntity modelToEntity(Platform model) {

    return PlatformEntity(
      id: model.id,
      name: model.name,
      iconFilename: model.iconFilename,
      type: typeToStringMap[model.type],
    );

  }

  static Platform entityToModel(PlatformEntity entity, [String? iconURL]) {

    return Platform(
      id: entity.id,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
      type: stringToTypeMap[entity.type],
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