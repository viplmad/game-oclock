import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformEntityData, PlatformID, PlatformView;

import 'query_utils.dart';


class PlatformQuery {
  PlatformQuery._();

  static Query create(PlatformEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(PlatformEntityData.table)
      .sets(entity.createMap())
      .returningField(PlatformEntityData.idField);

    return query;
  }

  static Query updateById(PlatformID id, PlatformEntity entity, PlatformEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(PlatformEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateIconById(PlatformID id, String? iconName) {
    final Query query = FluentQuery
      .update()
      .table(PlatformEntityData.table)
      .set(PlatformEntityData.iconField, iconName);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(PlatformID id) {
    final Query query = FluentQuery
      .delete()
      .from(PlatformEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(PlatformID id) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll([int? page]) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table);

    addFields(query);
    QueryUtils.paginate(query, page);

    return query;
  }

  static Query selectAllInView(PlatformView view, [int? page]) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table);

    addFields(query);
    _completeView(query, view);
    QueryUtils.paginate(query, page);

    return query;
  }

  static Query selectFirstInView(PlatformView view, int limit) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table)
      .limit(limit);

    addFields(query);
    _completeView(query, view);

    return query;
  }

  static Query selectFirstByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table)
      .where(PlatformEntityData.nameField, name, type: String, table: PlatformEntityData.table, operator: OperatorType.like)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectFirstInViewByNameLike(PlatformView view, String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table)
      .limit(limit);

    addFields(query);
    _completeView(query, view);
    query.where(PlatformEntityData.nameField, name, type: String, table: PlatformEntityData.table, operator: OperatorType.like);

    return query;
  }

  static void addFields(Query query) {
    query.field(PlatformEntityData.idField, type: int, table: PlatformEntityData.table);
    query.field(PlatformEntityData.nameField, type: String, table: PlatformEntityData.table);
    query.field(PlatformEntityData.iconField, type: String, table: PlatformEntityData.table);
    query.field(PlatformEntityData.typeField, type: String, table: PlatformEntityData.table);
  }

  static void _addIdWhere(PlatformID id, Query query) {
    query.where(PlatformEntityData.idField, id.id, type: int, table: PlatformEntityData.table);
  }

  static void _completeView(Query query, PlatformView view) {
    switch(view) {
      case PlatformView.main:
        query.order(PlatformEntityData.typeField, PlatformEntityData.table);
        query.order(PlatformEntityData.nameField, PlatformEntityData.table);
        break;
      case PlatformView.lastCreated:
        query.order(PlatformEntityData.idField, PlatformEntityData.table, direction: SortOrder.desc);
        break;
    }
  }
}