import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';


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
}