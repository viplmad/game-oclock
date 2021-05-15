import 'entity.dart';


class DLCPurchaseRelationData {
  DLCPurchaseRelationData._();
  
  static const String table = 'DLC-Purchase';

  static const String _dlcField = DLCEntityData.relationField;
  static const String _purchaseField = PurchaseEntityData.relationField;

  static const Map<String, Type> fields = <String, Type>{
    _dlcField : int,
    _purchaseField : int,
  };

  static Map<String, dynamic> getIdMap(int dlcId, int purchaseId) {

    return <String, dynamic>{
      _dlcField : dlcId,
      _purchaseField : purchaseId,
    };

  }
}