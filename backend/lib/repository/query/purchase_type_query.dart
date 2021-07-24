import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeEntityData, PurchaseTypeID, TypeView;


class PurchaseTypeQuery {
  PurchaseTypeQuery._();

  static Query create(PurchaseTypeEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(PurchaseTypeEntityData.table)
      .sets(entity.createMap())
      .returningField(PurchaseTypeEntityData.idField);

    return query;
  }

  static Query updateById(PurchaseTypeID id, PurchaseTypeEntity entity, PurchaseTypeEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(PurchaseTypeEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(PurchaseTypeID id) {
    final Query query = FluentQuery
      .delete()
      .from(PurchaseTypeEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(PurchaseTypeID id) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table)
      .where(PurchaseTypeEntityData.nameField, name, type: String, table: PurchaseTypeEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(TypeView view, [int? limit]) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table)
      .limit(limit);

    addFields(query);
    _addViewWhere(query, view);
    _addViewOrder(query, view);

    return query;
  }

  static void addFields(Query query) {
    query.field(PurchaseTypeEntityData.idField, type: int, table: PurchaseTypeEntityData.table);
    query.field(PurchaseTypeEntityData.nameField, type: String, table: PurchaseTypeEntityData.table);
  }

  static void _addIdWhere(PurchaseTypeID id, Query query) {
    query.where(PurchaseTypeEntityData.idField, id.id, type: int, table: PurchaseTypeEntityData.table);
  }

  static void _addViewWhere(Query query, TypeView view) {
    switch(view) {
      case TypeView.Main:
        break;
      case TypeView.LastCreated:
        break;
    }
  }

  static void _addViewOrder(Query query, TypeView view) {
    switch(view) {
      case TypeView.Main:
        break;
      case TypeView.LastCreated:
        query.order(PurchaseTypeEntityData.idField, PurchaseTypeEntityData.table, direction: SortOrder.DESC);
        break;
    }
  }
}