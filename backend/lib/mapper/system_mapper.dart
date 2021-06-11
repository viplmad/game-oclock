import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


class SystemMapper {
  SystemMapper._();

  static SystemEntity modelToEntity(System model) {

    return SystemEntity(
      id: model.id,
      name: model.name,
      iconFilename: model.iconFilename,
      generation: model.generation,
      manufacturer: model.manufacturer,
    );

  }

  static System entityToModel(SystemEntity entity, [String? iconURL]) {

    return System(
      id: entity.id,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
      generation: entity.generation,
      manufacturer: entity.manufacturer,
    );

  }
}