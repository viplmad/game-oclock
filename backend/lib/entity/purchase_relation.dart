import 'entity.dart';


class PurchaseTypeRelationData {
  PurchaseTypeRelationData._();

  static const String table = 'Purchase-Type';

  static const String purchaseField = PurchaseEntityData.relationField;
  static const String typeField = PurchaseTypeEntityData.relationField;
}