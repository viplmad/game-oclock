import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show StoreEntity, StoreEntityData, StoreID, StoreView;

import 'query_utils.dart';


class StoreQuery {
  StoreQuery._();

  static Query create(StoreEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(StoreEntityData.table)
      .sets(entity.createMap())
      .returningField(StoreEntityData.idField);

    return query;
  }

  static Query updateById(StoreID id, StoreEntity entity, StoreEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(StoreEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateIconById(StoreID id, String? iconName) {
    final Query query = FluentQuery
      .update()
      .table(StoreEntityData.table)
      .set(StoreEntityData.iconField, iconName);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(StoreID id) {
    final Query query = FluentQuery
      .delete()
      .from(StoreEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(StoreID id) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll([int? page]) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table);

    addFields(query);
    QueryUtils.paginate(query, page);

    return query;
  }

  static Query selectAllInView(StoreView view, [int? page]) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table);

    addFields(query);
    _completeView(query, view);
    QueryUtils.paginate(query, page);

    return query;
  }

  static Query selectFirstInView(StoreView view, int limit) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table)
      .limit(limit);

    addFields(query);
    _completeView(query, view);

    return query;
  }

  static Query selectFirstByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table)
      .where(StoreEntityData.nameField, name, type: String, table: StoreEntityData.table, operator: OperatorType.like)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectFirstInViewByNameLike(StoreView view, String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table)
      .limit(limit);

    addFields(query);
    _completeView(query, view);
    query.where(StoreEntityData.nameField, name, type: String, table: StoreEntityData.table, operator: OperatorType.like);

    return query;
  }

  static void addFields(Query query) {
    query.field(StoreEntityData.idField, type: int, table: StoreEntityData.table);
    query.field(StoreEntityData.nameField, type: String, table: StoreEntityData.table);
    query.field(StoreEntityData.iconField, type: String, table: StoreEntityData.table);
  }

  static void _addIdWhere(StoreID id, Query query) {
    query.where(StoreEntityData.idField, id.id, type: int, table: StoreEntityData.table);
  }

  static void _completeView(Query query, StoreView view) {
    switch(view) {
      case StoreView.main:
        query.order(StoreEntityData.nameField, StoreEntityData.table);
        break;
      case StoreView.lastCreated:
        query.order(StoreEntityData.idField, StoreEntityData.table, direction: SortOrder.desc);
        break;
    }
  }
}