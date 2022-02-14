import 'entity.dart';

class DLCPurchaseRelationData {
  DLCPurchaseRelationData._();

  static const String table = 'DLC-Purchase';

  static const String dlcField = DLCEntityData.relationField;
  static const String purchaseField = PurchaseEntityData.relationField;
}
