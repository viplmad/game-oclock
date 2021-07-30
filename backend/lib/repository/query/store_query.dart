import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show StoreEntity, StoreEntityData, StoreID, StoreView;


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

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table)
      .where(StoreEntityData.nameField, name, type: String, table: StoreEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(StoreView view, [int? limit]) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table);

    addFields(query);
    _completeView(query, view, limit);

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

  static void _completeView(Query query, StoreView view, int? limit) {
    switch(view) {
      case StoreView.Main:
        query.order(StoreEntityData.nameField, StoreEntityData.table);
        query.limit(limit);
        break;
      case StoreView.LastCreated:
        query.order(StoreEntityData.idField, StoreEntityData.table, direction: SortOrder.DESC);
        query.limit(limit?? 50);
        break;
    }
  }
}