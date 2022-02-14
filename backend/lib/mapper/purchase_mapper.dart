import 'package:backend/entity/entity.dart' show PurchaseEntity;
import 'package:backend/model/model.dart' show Purchase;

class PurchaseMapper {
  PurchaseMapper._();

  static PurchaseEntity modelToEntity(Purchase model) {
    return PurchaseEntity(
      id: model.id,
      description: model.description,
      price: model.price,
      externalCredit: model.externalCredit,
      date: model.date,
      originalPrice: model.originalPrice,
      store: model.store,
    );
  }

  static Purchase entityToModel(PurchaseEntity entity) {
    return Purchase(
      id: entity.id,
      description: entity.description,
      price: entity.price,
      externalCredit: entity.externalCredit,
      date: entity.date,
      originalPrice: entity.originalPrice,
      store: entity.store,
    );
  }

  static Future<Purchase> futureEntityToModel(
    Future<PurchaseEntity> entityFuture,
  ) {
    return entityFuture.asStream().map(entityToModel).first;
  }

  static Future<List<Purchase>> futureEntityListToModelList(
    Future<List<PurchaseEntity>> entityListFuture,
  ) {
    return entityListFuture.asStream().map((List<PurchaseEntity> entityList) {
      return entityList.map(entityToModel).toList(growable: false);
    }).first;
  }
}
