import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


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
}