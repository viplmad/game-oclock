import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeEntityData, PurchaseTypeID, PurchaseTypeView;

import 'query_utils.dart';


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

  static Query selectAll([int? page]) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table);

    addFields(query);
    QueryUtils.paginate(query, page);

    return query;
  }

  static Query selectFirstByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table)
      .where(PurchaseTypeEntityData.nameField, name, type: String, table: PurchaseTypeEntityData.table, operator: OperatorType.like)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(PurchaseTypeView view, [int? page]) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table);

    addFields(query);
    _completeView(query, view);
    QueryUtils.paginate(query, page);

    return query;
  }

  static Query selectFirstInView(PurchaseTypeView view, int limit) {
    final Query query = FluentQuery
      .select()
      .from(PurchaseTypeEntityData.table)
      .limit(limit);

    addFields(query);
    _completeView(query, view);

    return query;
  }

  static void addFields(Query query) {
    query.field(PurchaseTypeEntityData.idField, type: int, table: PurchaseTypeEntityData.table);
    query.field(PurchaseTypeEntityData.nameField, type: String, table: PurchaseTypeEntityData.table);
  }

  static void _addIdWhere(PurchaseTypeID id, Query query) {
    query.where(PurchaseTypeEntityData.idField, id.id, type: int, table: PurchaseTypeEntityData.table);
  }

  static void _completeView(Query query, PurchaseTypeView view) {
    switch(view) {
      case PurchaseTypeView.main:
        query.order(PurchaseTypeEntityData.nameField, PurchaseTypeEntityData.table);
        break;
      case PurchaseTypeView.lastCreated:
        query.order(PurchaseTypeEntityData.idField, PurchaseTypeEntityData.table, direction: SortOrder.desc);
        break;
    }
  }
}