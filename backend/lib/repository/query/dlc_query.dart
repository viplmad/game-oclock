import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show DLCEntity, DLCID, GameID, DLCEntityData, GameEntityData, DLCView;

import 'query.dart' show GameQuery;


class DLCQuery {
  DLCQuery._();

  static Query create(DLCEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(DLCEntityData.table)
      .sets(entity.createMap())
      .returningField(DLCEntityData.idField);

    return query;
  }

  static Query updateById(DLCID id, DLCEntity entity, DLCEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(DLCEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateCoverById(DLCID id, String? coverName) {
    final Query query = FluentQuery
      .update()
      .table(DLCEntityData.table)
      .set(DLCEntityData.coverField, coverName);

    _addIdWhere(id, query);

    return query;
  }

  static Query updateBaseGameById(DLCID id, GameID? baseGame) {
    final Query query = FluentQuery
      .update()
      .table(DLCEntityData.table)
      .set(DLCEntityData.baseGameField, baseGame?.id);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(DLCID id) {
    final Query query = FluentQuery
      .delete()
      .from(DLCEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(DLCID id) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table)
      .where(DLCEntityData.nameField, name, type: String, table: DLCEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(DLCView view, [int? limit]) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table)
      .limit(limit);

    addFields(query);
    _addViewWhere(query, view);
    _addViewOrder(query, view);

    return query;
  }

  static Query selectAllByBaseGame(GameID id) {
    final Query query = FluentQuery
      .select()
      .from(DLCEntityData.table)
      .where(DLCEntityData.baseGameField, id.id, type: int, table: DLCEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectGameByDLC(DLCID id) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .join(DLCEntityData.table, null, DLCEntityData.baseGameField, GameEntityData.table, GameEntityData.idField)
      .where(DLCEntityData.idField, id.id, type: int, table: DLCEntityData.table);

    GameQuery.addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(DLCEntityData.idField, type: int, table: DLCEntityData.table);
    query.field(DLCEntityData.nameField, type: String, table: DLCEntityData.table);
    query.field(DLCEntityData.releaseYearField, type: int, table: DLCEntityData.table);
    query.field(DLCEntityData.coverField, type: String, table: DLCEntityData.table);
    query.field(DLCEntityData.finishDateField, type: DateTime, table: DLCEntityData.table);

    query.field(DLCEntityData.baseGameField, type: int, table: DLCEntityData.table);
  }

  static void _addIdWhere(DLCID id, Query query) {
    query.where(DLCEntityData.idField, id.id, type: int, table: DLCEntityData.table);
  }

  static void _addViewWhere(Query query, DLCView view) {
    switch(view) {
      case DLCView.Main:
        // TODO: Handle this case.
        break;
      case DLCView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }

  static void _addViewOrder(Query query, DLCView view) {
    switch(view) {
      case DLCView.Main:
        // TODO: Handle this case.
        break;
      case DLCView.LastCreated:
        // TODO: Handle this case.
        break;
    }
  }
}