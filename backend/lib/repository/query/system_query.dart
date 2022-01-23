import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show SystemEntity, SystemID, SystemEntityData, SystemView;


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

  static Query updateById(SystemID id, SystemEntity entity, SystemEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(SystemEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateIconById(SystemID id, String? iconName) {
    final Query query = FluentQuery
      .update()
      .table(SystemEntityData.table)
      .set(SystemEntityData.iconField, iconName);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(SystemID id) {
    final Query query = FluentQuery
      .delete()
      .from(SystemEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(SystemID id) {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table)
      .where(SystemEntityData.nameField, name, type: String, table: SystemEntityData.table, operator: OperatorType.like)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(SystemView view, [int? limit]) {
    final Query query = FluentQuery
      .select()
      .from(SystemEntityData.table);

    addFields(query);
    _completeView(query, view, limit);

    return query;
  }

  static void addFields(Query query) {
    query.field(SystemEntityData.idField, type: int, table: SystemEntityData.table);
    query.field(SystemEntityData.nameField, type: String, table: SystemEntityData.table);
    query.field(SystemEntityData.iconField, type: String, table: SystemEntityData.table);
    query.field(SystemEntityData.generationField, type: int, table: SystemEntityData.table);
    query.field(SystemEntityData.manufacturerField, type: String, table: SystemEntityData.table);
  }

  static void _addIdWhere(SystemID id, Query query) {
    query.where(SystemEntityData.idField, id.id, type: int, table: SystemEntityData.table);
  }

  static void _completeView(Query query, SystemView view, int? limit) {
    switch(view) {
      case SystemView.main:
        query.order(SystemEntityData.generationField, SystemEntityData.table);
        query.order(SystemEntityData.manufacturerField, SystemEntityData.table);
        query.order(SystemEntityData.nameField, SystemEntityData.table);
        query.limit(limit);
        break;
      case SystemView.lastCreated:
        query.order(SystemEntityData.idField, SystemEntityData.table, direction: SortOrder.desc);
        query.limit(limit?? 50);
        break;
    }
  }
}