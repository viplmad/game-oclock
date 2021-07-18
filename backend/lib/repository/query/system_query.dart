import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show SystemEntity, SystemEntityData;
import 'package:backend/model/model.dart' show SystemView;


class SystemQuery {
  SystemQuery._();

  static Query create(SystemEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(SystemEntityData.table)
      .sets(entity.createMap())
      .returningField(SystemEntityData.idField);

    return query;
  }

  static Query updateById(int id, SystemEntity entity, SystemEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(SystemEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateIconById(int id, String? iconName) {
    final Query query = FluentQuery
      .update()
      .table(SystemEntityData.table)
      .set(SystemEntityData.iconField, iconName);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(int id) {
    final Query query = FluentQuery
      .delete()
      .from(SystemEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(int id) {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table)
      .where(SystemEntityData.nameField, name, type: String, table: SystemEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(SystemView view, [int? limit]) {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table)
      .limit(limit);

    addFields(query);
    _addViewWhere(query, view);
    _addViewOrder(query, view);

    return query;
  }

  static void addFields(Query query) {
    query.field(SystemEntityData.idField, type: int, table: SystemEntityData.table);
    query.field(SystemEntityData.nameField, type: String, table: SystemEntityData.table);
    query.field(SystemEntityData.iconField, type: String, table: SystemEntityData.table);
    query.field(SystemEntityData.generationField, type: int, table: SystemEntityData.table);
    query.field(SystemEntityData.manufacturerField, type: String, table: SystemEntityData.table);
  }

  static void _addIdWhere(int id, Query query) {
    query.where(SystemEntityData.idField, id, type: int, table: SystemEntityData.table);
  }

  static void _addViewWhere(Query query, SystemView view) {
    switch(view) {
      case SystemView.Main:
        break;
      case SystemView.LastCreated:
        break;
    }
  }

  static void _addViewOrder(Query query, SystemView view) {
    switch(view) {
      case SystemView.Main:
        break;
      case SystemView.LastCreated:
        query.order(SystemEntityData.idField, SystemEntityData.table, direction: SortOrder.DESC);
        break;
    }
  }
}