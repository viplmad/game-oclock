import 'package:query/query.dart';

import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';
import 'repository.dart';


class PurchaseRepository {
  PurchaseRepository._();

  static Query create(PurchaseEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(PurchaseEntityData.table)
      .sets(entity.createMap())
      .returningField(PurchaseEntityData.idField);

    return query;
  }

  static Query updateById(int id, PurchaseEntity entity, PurchaseEntity updatedEntity, PurchaseUpdateProperties updateProperties) {
    final Query query = FluentQuery
      .update()
      .table(PurchaseEntityData.table)
      .sets(entity.updateMap(updatedEntity, updateProperties));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateStoreById(int id, int? store) {
    final Query query = FluentQuery
      .update()
      .table(PurchaseEntityData.table)
      .set(PurchaseEntityData.storeField, store);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(int id) {
    final Query query = FluentQuery
      .delete()
      .from(PurchaseEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(int id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

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
      .from(PurchaseEntityData.table)
      .limit(limit);

    addFields(query);
    _addViewWhere(query, view, year);
    _addViewOrder(query, view);

    return query;
  }

  static Query selectAllByStore(int id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseEntityData.table)
      .where(PurchaseEntityData.storeField, id, type: int, table: PurchaseEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectStoreByPurchase(int id) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table)
      .join(PurchaseEntityData.table, null, PurchaseEntityData.storeField, StoreEntityData.table, StoreEntityData.idField)
      .where(PurchaseEntityData.idField, id, type: int, table: PurchaseEntityData.table);

    StoreRepository.addFields(query);

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

  static void _addIdWhere(int id, Query query) {
    query.where(PurchaseEntityData.idField, id, type: int, table: PurchaseEntityData.table);
  }

  static void _addViewWhere(Query query, PurchaseView view, [int? year]) {
    switch(view) {
      case PurchaseView.Main:
        // TODO: Handle this case.
        break;
      case PurchaseView.LastCreated:
        // TODO: Handle this case.
        break;
      case PurchaseView.Pending:
        // TODO: Handle this case.
        break;
      case PurchaseView.LastPurchased:
        // TODO: Handle this case.
        break;
      case PurchaseView.Review:
        // TODO: Handle this case.
        break;
    }
  }

  static void _addViewOrder(Query query, PurchaseView view) {
    switch(view) {
      case PurchaseView.Main:
        // TODO: Handle this case.
        break;
      case PurchaseView.LastCreated:
        // TODO: Handle this case.
        break;
      case PurchaseView.Pending:
        // TODO: Handle this case.
        break;
      case PurchaseView.LastPurchased:
        // TODO: Handle this case.
        break;
      case PurchaseView.Review:
        // TODO: Handle this case.
        break;
    }
  }
}