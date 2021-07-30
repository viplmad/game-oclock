import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show DLCPurchaseRelationData, GamePurchaseRelationData, PurchaseEntity, PurchaseEntityData, PurchaseID, PurchaseView, StoreEntityData, StoreID;

import 'query.dart' show StoreQuery;


class PurchaseQuery {
  PurchaseQuery._();

  static Query create(PurchaseEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(PurchaseEntityData.table)
      .sets(entity.createMap())
      .returningField(PurchaseEntityData.idField);

    return query;
  }

  static Query updateById(PurchaseID id, PurchaseEntity entity, PurchaseEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(PurchaseEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateStoreById(PurchaseID id, StoreID? store) {
    final Query query = FluentQuery
      .update()
      .table(PurchaseEntityData.table)
      .set(PurchaseEntityData.storeField, store?.id);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(PurchaseID id) {
    final Query query = FluentQuery
      .delete()
      .from(PurchaseEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(PurchaseID id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByDescriptionLike(String description, int limit) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table)
      .where(PurchaseEntityData.descriptionField, description, type: String, table: PurchaseEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(PurchaseView view, [int? limit, int? year]) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table);

    addFields(query);
    _completeView(query, view, limit, year);

    return query;
  }

  static Query selectAllByStore(StoreID id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table)
      .where(PurchaseEntityData.storeField, id.id, type: int, table: PurchaseEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectStoreByPurchase(PurchaseID id) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table)
      .join(PurchaseEntityData.table, null, PurchaseEntityData.storeField, StoreEntityData.table, StoreEntityData.idField)
      .where(PurchaseEntityData.idField, id.id, type: int, table: PurchaseEntityData.table);

    StoreQuery.addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(PurchaseEntityData.idField, type: int, table: PurchaseEntityData.table);
    query.field(PurchaseEntityData.descriptionField, type: String, table: PurchaseEntityData.table);
    query.field(PurchaseEntityData.priceField, type: double, table: PurchaseEntityData.table);
    query.field(PurchaseEntityData.externalCreditField, type: double, table: PurchaseEntityData.table);
    query.field(PurchaseEntityData.dateField, type: DateTime, table: PurchaseEntityData.table);
    query.field(PurchaseEntityData.originalPriceField, type: double, table: PurchaseEntityData.table);

    query.field(PurchaseEntityData.storeField, type: int, table: PurchaseEntityData.table);
  }

  static void _addIdWhere(PurchaseID id, Query query) {
    query.where(PurchaseEntityData.idField, id.id, type: int, table: PurchaseEntityData.table);
  }

  static void _completeView(Query query, PurchaseView view, int? limit, [int? year]) {
    switch(view) {
      case PurchaseView.Main:
        query.order(PurchaseEntityData.dateField, PurchaseEntityData.table, direction: SortOrder.DESC);
        query.order(PurchaseEntityData.descriptionField, PurchaseEntityData.table);
        query.limit(limit);
        break;
      case PurchaseView.LastCreated:
        query.order(PurchaseEntityData.idField, PurchaseEntityData.table, direction: SortOrder.DESC);
        query.limit(limit?? 50);
        break;
      case PurchaseView.Pending:
        query.where(PurchaseEntityData.dateField, null, type: DateTime, table: PurchaseEntityData.table);

        final Query countGamePurchase = FluentQuery
          .select()
          .field(GamePurchaseRelationData.gameField, type: int, table: GamePurchaseRelationData.table, function: FunctionType.COUNT)
          .from(GamePurchaseRelationData.table)
          .whereFields(GamePurchaseRelationData.table, GamePurchaseRelationData.purchaseField, PurchaseEntityData.table, PurchaseEntityData.idField);
        query.orWhereSubquery(countGamePurchase, 0, divider: DividerType.START);

        final Query countDLCPurchase = FluentQuery
          .select()
          .field(DLCPurchaseRelationData.dlcField, type: int, table: DLCPurchaseRelationData.table, function: FunctionType.COUNT)
          .from(DLCPurchaseRelationData.table)
          .whereFields(DLCPurchaseRelationData.table, DLCPurchaseRelationData.purchaseField, PurchaseEntityData.table, PurchaseEntityData.idField);
        query.whereSubquery(countDLCPurchase, 0, divider: DividerType.END);

        query.order(PurchaseEntityData.descriptionField, PurchaseEntityData.table);
        break;
      case PurchaseView.LastPurchased:
        query.where(PurchaseEntityData.dateField, null, type: DateTime, table: PurchaseEntityData.table, operator: OperatorType.NOT_EQ);
        query.order(PurchaseEntityData.dateField, PurchaseEntityData.table, direction: SortOrder.DESC, nullsLast: true);
        query.order(PurchaseEntityData.descriptionField, PurchaseEntityData.table);
        query.limit(limit?? 100);
        break;
      case PurchaseView.Review:
        year = year?? DateTime.now().year;
        query.whereDatePart(PurchaseEntityData.dateField, year, DatePart.YEAR, table: PurchaseEntityData.table);
        query.order(PurchaseEntityData.dateField, PurchaseEntityData.table);
        query.order(PurchaseEntityData.descriptionField, PurchaseEntityData.table);
        break;
    }
  }
}