import 'entity.dart';


class PurchaseTypeRelationData {
  PurchaseTypeRelationData._();

  static const String table = 'Purchase-Type';

  static const String _purchaseField = PurchaseEntityData.relationField;
  static const String _typeField = PurchaseTypeEntityData.relationField;

  static const Map<String, Type> fields = <String, Type>{
    _purchaseField : int,
    _typeField : int,
  };

  static Map<String, dynamic> getIdMap(int purchaseId, int typeId) {

    return <String, dynamic>{
      _purchaseField : purchaseId,
      _typeField : typeId,
    };

  }
}