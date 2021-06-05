import 'package:backend/query/query.dart';

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

  static Query getIdQuery(int purchaseId, int typeId) {

    final Query idQuery = Query();
    idQuery.addAnd(_purchaseField, purchaseId);
    idQuery.addAnd(_typeField, typeId);

    return idQuery;

  }

  static Map<String, dynamic> getCreateDynamicMap(int purchaseId, int typeId) {

    return <String, dynamic>{
      _purchaseField : purchaseId,
      _typeField : typeId,
    };

  }
}