import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameTagEntity, GameTagEntityData;
import 'package:backend/model/model.dart' show TagView;


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

  static Query updateById(int id, GameTagEntity entity, GameTagEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(GameTagEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(int id) {
    final Query query = FluentQuery
      .delete()
      .from(GameTagEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(int id) {
    final Query query = FluentQuery
      .select()
      .from(GameTagEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

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

  static Query selectAllInView(TagView view, [int? limit]) {
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

  static void _addIdWhere(int id, Query query) {
    query.where(GameTagEntityData.idField, id, type: int, table: GameTagEntityData.table);
  }

  static void _addViewWhere(Query query, TagView view) {
    switch(view) {
      case TagView.Main:
        // TODO: Handle this case.
        break;
      case TagView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }

  static void _addViewOrder(Query query, TagView view) {
    switch(view) {
      case TagView.Main:
        // TODO: Handle this case.
        break;
      case TagView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }
}