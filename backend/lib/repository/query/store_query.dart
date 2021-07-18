import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show StoreEntity, StoreEntityData;
import 'package:backend/model/model.dart' show StoreView;


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

  static Query updateById(int id, StoreEntity entity, StoreEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(StoreEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateIconById(int id, String? iconName) {
    final Query query = FluentQuery
      .update()
      .table(StoreEntityData.table)
      .set(StoreEntityData.iconField, iconName);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(int id) {
    final Query query = FluentQuery
      .delete()
      .from(StoreEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(int id) {
    final Query query = FluentQuery
      .select()
      .from(StoreEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

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
      .from(StoreEntityData.table)
      .limit(limit);

    addFields(query);
    _addViewWhere(query, view);
    _addViewOrder(query, view);

    return query;
  }

  static void addFields(Query query) {
    query.field(StoreEntityData.idField, type: int, table: StoreEntityData.table);
    query.field(StoreEntityData.nameField, type: String, table: StoreEntityData.table);
    query.field(StoreEntityData.iconField, type: String, table: StoreEntityData.table);
  }

  static void _addIdWhere(int id, Query query) {
    query.where(StoreEntityData.idField, id, type: int, table: StoreEntityData.table);
  }

  static void _addViewWhere(Query query, StoreView view, [int? year]) {
    switch(view) {
      case StoreView.Main:
        // TODO: Handle this case.
        break;
      case StoreView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }

  static void _addViewOrder(Query query, StoreView view) {
    switch(view) {
      case StoreView.Main:
        // TODO: Handle this case.
        break;
      case StoreView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }
}