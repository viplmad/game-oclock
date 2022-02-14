import 'package:query/query.dart';

import 'package:backend/entity/entity.dart'
    show
        DLCEntityData,
        DLCID,
        DLCPurchaseRelationData,
        PurchaseEntityData,
        PurchaseID;

import 'query.dart' show DLCQuery, PurchaseQuery;

class DLCPurchaseRelationQuery {
  DLCPurchaseRelationQuery._();

  static Query create(DLCID dlcId, PurchaseID purchaseId) {
    final Query query = FluentQuery.insert()
        .into(DLCPurchaseRelationData.table)
        .set(DLCPurchaseRelationData.dlcField, dlcId.id)
        .set(DLCPurchaseRelationData.purchaseField, purchaseId.id);

    return query;
  }

  static Query deleteById(DLCID dlcId, PurchaseID purchaseId) {
    final Query query =
        FluentQuery.delete().from(DLCPurchaseRelationData.table);

    _addIdWhere(dlcId, purchaseId, query);

    return query;
  }

  static Query selectAllDLCsByPurchaseId(PurchaseID id) {
    final Query query = FluentQuery.select()
        .from(DLCEntityData.table)
        .join(
          DLCPurchaseRelationData.table,
          null,
          DLCPurchaseRelationData.dlcField,
          DLCEntityData.table,
          DLCEntityData.idField,
        )
        .where(
          DLCPurchaseRelationData.purchaseField,
          id.id,
          type: int,
          table: DLCPurchaseRelationData.table,
        );

    DLCQuery.addFields(query);

    return query;
  }

  static Query selectAllPurchasesByDLCId(DLCID id) {
    final Query query = FluentQuery.select()
        .from(PurchaseEntityData.table)
        .join(
          DLCPurchaseRelationData.table,
          null,
          DLCPurchaseRelationData.purchaseField,
          PurchaseEntityData.table,
          PurchaseEntityData.idField,
        )
        .where(
          DLCPurchaseRelationData.dlcField,
          id.id,
          type: int,
          table: DLCPurchaseRelationData.table,
        );

    PurchaseQuery.addFields(query);

    return query;
  }

  static void _addIdWhere(DLCID dlcId, PurchaseID purchaseId, Query query) {
    query.where(
      DLCPurchaseRelationData.dlcField,
      dlcId.id,
      type: int,
      table: DLCPurchaseRelationData.table,
    );
    query.where(
      DLCPurchaseRelationData.purchaseField,
      purchaseId.id,
      type: int,
      table: DLCPurchaseRelationData.table,
    );
  }
}
