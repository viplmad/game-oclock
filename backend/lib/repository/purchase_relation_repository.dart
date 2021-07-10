import 'package:query/query.dart';

import 'package:backend/entity/entity.dart';
import 'repository.dart';


class PurchaseTypeRelationRepository {
  PurchaseTypeRelationRepository._();

  static Query create(int purchaseId, int typeId) {
    final Query query = FluentQuery
      .insert()
      .into(PurchaseTypeRelationData.table)
      .set(PurchaseTypeRelationData.purchaseField, purchaseId)
      .set(PurchaseTypeRelationData.typeField, typeId);

    return query;
  }

  static Query deleteById(int purchaseId, int typeId) {
    final Query query = FluentQuery
      .delete()
      .from(PurchaseTypeRelationData.table);

    _addIdWhere(purchaseId, typeId, query);

    return query;
  }

  static Query selectAllPurchasesByTypeId(int id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table)
      .join(PurchaseTypeRelationData.table, null, PurchaseTypeRelationData.purchaseField, PurchaseEntityData.table, PurchaseEntityData.idField)
      .where(PurchaseTypeRelationData.typeField, id, type: int, table: PurchaseTypeRelationData.table);

    PurchaseRepository.addFields(query);

    return query;
  }

  static Query selectAllTypesByPurchaseId(int id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table)
      .join(PurchaseTypeRelationData.table, null, PurchaseTypeRelationData.typeField, PurchaseTypeEntityData.table, PurchaseTypeEntityData.idField)
      .where(PurchaseTypeRelationData.purchaseField, id, type: int, table: PurchaseTypeRelationData.table);

    PurchaseTypeRepository.addFields(query);

    return query;
  }

  static void _addIdWhere(int purchaseId, int typeId, Query query) {
    query.where(PurchaseTypeRelationData.purchaseField, purchaseId, type: int, table: PurchaseTypeRelationData.table);
    query.where(PurchaseTypeRelationData.typeField, typeId, type: int, table: PurchaseTypeRelationData.table);
  }
}