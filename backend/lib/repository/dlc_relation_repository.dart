import 'package:query/query.dart';

import 'package:backend/entity/entity.dart';
import 'repository.dart';


class DLCPurchaseRelationRepository {
  DLCPurchaseRelationRepository._();

  static Query create(int dlcId, int purchaseId) {
    final Query query = FluentQuery
      .insert()
      .into(DLCPurchaseRelationData.table)
      .set(DLCPurchaseRelationData.dlcField, dlcId)
      .set(DLCPurchaseRelationData.purchaseField, purchaseId);

    return query;
  }

  static Query deleteById(int dlcId, int purchaseId) {
    final Query query = FluentQuery
      .delete()
      .from(DLCPurchaseRelationData.table);

    _addIdWhere(dlcId, purchaseId, query);

    return query;
  }

  static Query selectAllDLCsByPurchaseId(int id) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table)
      .join(DLCPurchaseRelationData.table, null, DLCPurchaseRelationData.dlcField, DLCEntityData.table, DLCEntityData.idField)
      .where(DLCPurchaseRelationData.purchaseField, id, type: int, table: DLCPurchaseRelationData.table);

    DLCRepository.addFields(query);

    return query;
  }

  static Query selectAllPurchasesByDLCId(int id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table)
      .join(DLCPurchaseRelationData.table, null, DLCPurchaseRelationData.purchaseField, PurchaseEntityData.table, PurchaseEntityData.idField)
      .where(DLCPurchaseRelationData.dlcField, id, type: int, table: DLCPurchaseRelationData.table);

    PurchaseRepository.addFields(query);

    return query;
  }

  static void _addIdWhere(int dlcId, int purchaseId, Query query) {
    query.where(DLCPurchaseRelationData.dlcField, dlcId, type: int, table: DLCPurchaseRelationData.table);
    query.where(DLCPurchaseRelationData.purchaseField, purchaseId, type: int, table: DLCPurchaseRelationData.table);
  }
}