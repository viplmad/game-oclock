import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


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
}