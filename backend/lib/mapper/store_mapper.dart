import 'package:backend/entity/entity.dart' show StoreEntity;
import 'package:backend/model/model.dart' show Store;

class StoreMapper {
  StoreMapper._();

  static StoreEntity modelToEntity(Store model) {
    return StoreEntity(
      id: model.id,
      name: model.name,
      iconFilename: model.iconFilename,
    );
  }

  static Store entityToModel(StoreEntity entity, [String? iconURL]) {
    return Store(
      id: entity.id,
      name: entity.name,
      iconURL: iconURL,
      iconFilename: entity.iconFilename,
    );
  }

  static Future<Store> futureEntityToModel(
    Future<StoreEntity> entityFuture,
    String? Function(String?) iconFunction,
  ) {
    return entityFuture.asStream().map((StoreEntity entity) {
      return entityToModel(entity, iconFunction(entity.iconFilename));
    }).first;
  }

  static Future<List<Store>> futureEntityListToModelList(
    Future<List<StoreEntity>> entityListFuture,
    String? Function(String?) iconFunction,
  ) {
    return entityListFuture.asStream().map((List<StoreEntity> entityList) {
      return entityList.map((StoreEntity entity) {
        return entityToModel(entity, iconFunction(entity.iconFilename));
      }).toList(growable: false);
    }).first;
  }
}
