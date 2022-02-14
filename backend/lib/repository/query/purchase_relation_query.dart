import 'package:query/query.dart';

import 'package:backend/entity/entity.dart'
    show
        PurchaseEntityData,
        PurchaseID,
        PurchaseTypeEntityData,
        PurchaseTypeID,
        PurchaseTypeRelationData;

import 'query.dart' show PurchaseQuery, PurchaseTypeQuery;

class PurchaseTypeRelationQuery {
  PurchaseTypeRelationQuery._();

  static Query create(PurchaseID purchaseId, PurchaseTypeID typeId) {
    final Query query = FluentQuery.insert()
        .into(PurchaseTypeRelationData.table)
        .set(PurchaseTypeRelationData.purchaseField, purchaseId.id)
        .set(PurchaseTypeRelationData.typeField, typeId.id);

    return query;
  }

  static Query deleteById(PurchaseID purchaseId, PurchaseTypeID typeId) {
    final Query query =
        FluentQuery.delete().from(PurchaseTypeRelationData.table);

    _addIdWhere(purchaseId, typeId, query);

    return query;
  }

  static Query selectAllPurchasesByTypeId(PurchaseTypeID id) {
    final Query query = FluentQuery.select()
        .from(PurchaseEntityData.table)
        .join(
          PurchaseTypeRelationData.table,
          null,
          PurchaseTypeRelationData.purchaseField,
          PurchaseEntityData.table,
          PurchaseEntityData.idField,
        )
        .where(
          PurchaseTypeRelationData.typeField,
          id.id,
          type: int,
          table: PurchaseTypeRelationData.table,
        );

    PurchaseQuery.addFields(query);

    return query;
  }

  static Query selectAllTypesByPurchaseId(PurchaseID id) {
    final Query query = FluentQuery.select()
        .from(PurchaseTypeEntityData.table)
        .join(
          PurchaseTypeRelationData.table,
          null,
          PurchaseTypeRelationData.typeField,
          PurchaseTypeEntityData.table,
          PurchaseTypeEntityData.idField,
        )
        .where(
          PurchaseTypeRelationData.purchaseField,
          id.id,
          type: int,
          table: PurchaseTypeRelationData.table,
        );

    PurchaseTypeQuery.addFields(query);

    return query;
  }

  static void _addIdWhere(
    PurchaseID purchaseId,
    PurchaseTypeID typeId,
    Query query,
  ) {
    query.where(
      PurchaseTypeRelationData.purchaseField,
      purchaseId.id,
      type: int,
      table: PurchaseTypeRelationData.table,
    );
    query.where(
      PurchaseTypeRelationData.typeField,
      typeId.id,
      type: int,
      table: PurchaseTypeRelationData.table,
    );
  }
}
