import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagEntityData, GameTagID, GameTagView;


class GameTagQuery {
  GameTagQuery._();

  static Query create(GameTagEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(GameTagEntityData.table)
      .sets(entity.createMap())
      .returningField(GameTagEntityData.idField);

    return query;
  }

  static Query updateById(GameTagID id, GameTagEntity entity, GameTagEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(GameTagEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(GameTagID id) {
    final Query query = FluentQuery
      .delete()
      .from(GameTagEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(GameTagID id) {
    final Query query = FluentQuery
      .select()
      .from(GameTagEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(GameTagEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(GameTagEntityData.table)
      .where(GameTagEntityData.nameField, name, type: String, table: GameTagEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(GameTagView view, [int? limit]) {
    final Query query = FluentQuery
      .select()
      .from(GameTagEntityData.table)
      .limit(limit);

    addFields(query);
    _addViewWhere(query, view);
    _addViewOrder(query, view);

    return query;
  }

  static void addFields(Query query) {
    query.field(GameTagEntityData.idField, type: int, table: GameTagEntityData.table);
    query.field(GameTagEntityData.nameField, type: String, table: GameTagEntityData.table);
  }

  static void _addIdWhere(GameTagID id, Query query) {
    query.where(GameTagEntityData.idField, id.id, type: int, table: GameTagEntityData.table);
  }

  static void _addViewWhere(Query query, GameTagView view) {
    switch(view) {
      case GameTagView.Main:
        // TODO: Handle this case.
        break;
      case GameTagView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }

  static void _addViewOrder(Query query, GameTagView view) {
    switch(view) {
      case GameTagView.Main:
        // TODO: Handle this case.
        break;
      case GameTagView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }
}