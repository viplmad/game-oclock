import 'package:backend/entity/entity.dart';
import 'package:backend/model/model.dart';
import 'package:query/query.dart';

class PlatformRepository {
  PlatformRepository._();

  static Query create(PlatformEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(PlatformEntityData.table)
      .sets(entity.createMap())
      .returningField(PlatformEntityData.idField);

    return query;
  }

  static Query updateById(int id, PlatformEntity entity, PlatformEntity updatedEntity, PlatformUpdateProperties updateProperties) {
    final Query query = FluentQuery
      .update()
      .table(PlatformEntityData.table)
      .sets(entity.updateMap(updatedEntity, updateProperties));

    return _addIdWhere(id, query);
  }

  static Query updateIconById(int id, String? iconName) {
    final Query query = FluentQuery
      .update()
      .table(PlatformEntityData.table)
      .set(PlatformEntityData.iconField, iconName);

    return _addIdWhere(id, query);
  }

  static Query deleteById(int id) {
    final Query query = FluentQuery
      .delete()
      .from(PlatformEntityData.table);

    return _addIdWhere(id, query);
  }

  static Query selectById(int id) {
    Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table);

    query = addFields(query);

    return _addIdWhere(id, query);
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table)
      .where(PlatformEntityData.nameField, name, type: String, table: PlatformEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    return query;
  }

  static Query selectAllInView(PlatformView view, [int? limit]) {
    Query query = FluentQuery
      .select()
      .from(PlatformEntityData.table)
      .limit(limit);

    query = addFields(query);
    query = _addViewWhere(query, view);
    query = _addViewOrder(query, view);

    return query;
  }

  static Query _addIdWhere(int id, Query query) {
    query.where(PlatformEntityData.idField, id, type: int, table: PlatformEntityData.table);

    return query;
  }

  static Query addFields(Query query) {
    query.field(PlatformEntityData.idField, type: int, table: PlatformEntityData.table);
    query.field(PlatformEntityData.nameField, type: String, table: PlatformEntityData.table);
    query.field(PlatformEntityData.iconField, type: String, table: PlatformEntityData.table);
    query.field(PlatformEntityData.typeField, type: String, table: PlatformEntityData.table);

    return query;
  }

  static Query _addViewWhere(Query query, PlatformView view) {
    switch(view) {
      case PlatformView.Main:
        break;
      case PlatformView.LastCreated:
        break;
    }

    return query;
  }

  static Query _addViewOrder(Query query, PlatformView view) {
    switch(view) {
      case PlatformView.Main:
        break;
      case PlatformView.LastCreated:
        query.order(PlatformEntityData.idField, PlatformEntityData.table, direction: SortOrder.DESC);
        break;
    }

    return query;
  }
}