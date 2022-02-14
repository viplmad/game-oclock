import 'package:backend/entity/entity.dart' show PurchaseTypeEntity;
import 'package:backend/model/model.dart' show PurchaseType;

class PurchaseTypeMapper {
  PurchaseTypeMapper._();

  static PurchaseTypeEntity modelToEntity(PurchaseType model) {
    return PurchaseTypeEntity(
      id: model.id,
      name: model.name,
    );
  }

  static PurchaseType entityToModel(PurchaseTypeEntity entity) {
    return PurchaseType(
      id: entity.id,
      name: entity.name,
    );
  }

  static Future<PurchaseType> futureEntityToModel(
    Future<PurchaseTypeEntity> entityFuture,
  ) {
    return entityFuture.asStream().map(entityToModel).first;
  }

  static Future<List<PurchaseType>> futureEntityListToModelList(
    Future<List<PurchaseTypeEntity>> entityListFuture,
  ) {
    return entityListFuture
        .asStream()
        .map((List<PurchaseTypeEntity> entityList) {
      return entityList.map(entityToModel).toList(growable: false);
    }).first;
  }
}
