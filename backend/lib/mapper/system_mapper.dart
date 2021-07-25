import 'package:backend/entity/entity.dart' show SystemEntity, nintendoValue, sonyValue, microsoftValue, segaValue;
import 'package:backend/model/model.dart' show System, Manufacturer;


class SystemMapper {
  SystemMapper._();

  static const Map<Manufacturer, String> manufacturerToStringMap = <Manufacturer, String> {
    Manufacturer.Nintendo: nintendoValue,
    Manufacturer.Sony: sonyValue,
    Manufacturer.Microsoft: microsoftValue,
    Manufacturer.Sega: segaValue,
  };

  static const Map<String, Manufacturer> stringToManufacturerMap = <String, Manufacturer> {
    nintendoValue: Manufacturer.Nintendo,
    sonyValue: Manufacturer.Sony,
    microsoftValue: Manufacturer.Microsoft,
    segaValue: Manufacturer.Sega,
  };

  static SystemEntity modelToEntity(System model) {

    return SystemEntity(
      id: model.id,
      name: model.name,
      iconFilename: model.iconFilename,
      generation: model.generation,
      manufacturer: manufacturerToStringMap[model.manufacturer],
    );

  }

  static System entityToModel(SystemEntity entity, [String? iconURL]) {

    return System(
      id: entity.id,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
      generation: entity.generation,
      manufacturer: stringToManufacturerMap[entity.manufacturer],
    );

  }

  static Future<System> futureEntityToModel(Future<SystemEntity> entityFuture, String? Function(String?) iconFunction) {

    return entityFuture.asStream().map( (SystemEntity entity) {
      return entityToModel(entity, iconFunction(entity.iconFilename));
    }).first;

  }

  static Future<List<System>> futureEntityListToModelList(Future<List<SystemEntity>> entityListFuture, String? Function(String?) iconFunction) {

    return entityListFuture.asStream().map( (List<SystemEntity> entityList) {
      return entityList.map( (SystemEntity entity) {
        return entityToModel(entity, iconFunction(entity.iconFilename));
      }).toList(growable: false);
    }).first;

  }
}