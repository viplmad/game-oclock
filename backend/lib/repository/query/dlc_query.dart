import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show DLCEntity, DLCEntityData, DLCFinishEntityData, DLCID, DLCView, GameEntityData, GameID;

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
      .from(DLCEntityData.table);

    addFields(query);
    _completeView(query, view, limit);

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

    final Query firstFinishQuery = FluentQuery
      .select()
      .field(DLCFinishEntityData.dateField, type: DateTime, table: DLCFinishEntityData.table, function: FunctionType.MIN)
      .from(DLCFinishEntityData.table)
      .whereFields(DLCFinishEntityData.table, DLCFinishEntityData.dlcField, DLCEntityData.table, DLCEntityData.idField);
    query.fieldSubquery(firstFinishQuery, alias: DLCEntityData.finishDateField);

    query.field(DLCEntityData.baseGameField, type: int, table: DLCEntityData.table);
  }

  static void _addIdWhere(DLCID id, Query query) {
    query.where(DLCEntityData.idField, id.id, type: int, table: DLCEntityData.table);
  }

  static void _completeView(Query query, DLCView view, int? limit) {
    switch(view) {
      case DLCView.Main:
        query.order(DLCEntityData.baseGameField, DLCEntityData.table);
        query.order(DLCEntityData.releaseYearField, DLCEntityData.table);
        query.order(DLCEntityData.nameField, DLCEntityData.table);
        query.limit(limit);
        break;
      case DLCView.LastCreated:
        query.order(DLCEntityData.idField, DLCEntityData.table, direction: SortOrder.DESC);
        query.limit(limit?? 50);
        break;
    }
  }
}