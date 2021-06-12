import 'package:backend/query/query.dart';

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

  static Query idQuery(int dlcId, int purchaseId) {

    final Query idQuery = Query();
    idQuery.addAnd(_dlcField, dlcId);
    idQuery.addAnd(_purchaseField, purchaseId);

    return idQuery;

  }

  static Map<String, dynamic> createDynamicMap(int dlcId, int purchaseId) {

    return <String, dynamic>{
      _dlcField : dlcId,
      _purchaseField : purchaseId,
    };

  }
}