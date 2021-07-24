import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameEntityData, GameID, GameTimeLogEntity, GameTimeLogEntityData, GameTimeLogID;

import 'query.dart' show GameQuery;


class GameTimeLogQuery {
  GameTimeLogQuery._();

  static Query create(GameTimeLogEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(GameTimeLogEntityData.table)
      .sets(entity.createMap());

    return query;
  }

  static Query updateById(GameTimeLogID id, GameTimeLogEntity entity, GameTimeLogEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(GameTimeLogEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(GameTimeLogID id) {
    final Query query = FluentQuery
      .delete()
      .from(GameTimeLogEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(GameTimeLogID id) {
    final Query query = FluentQuery
      .select()
      .from(GameTimeLogEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(GameTimeLogEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByGame(GameID id) {
    final Query query = FluentQuery
      .select()
      .from(GameTimeLogEntityData.table)
      .where(GameTimeLogEntityData.gameField, id, type: int, table: GameTimeLogEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllWithGameByYear(int year) {
    final Query query = FluentQuery
      .select()
      .from(GameTimeLogEntityData.table)
      .join(GameEntityData.table, null, GameEntityData.idField, GameTimeLogEntityData.gameField, GameTimeLogEntityData.gameField, type: JoinType.LEFT)
      .whereDatePart(GameTimeLogEntityData.dateTimeField, year, DatePart.YEAR, table: GameTimeLogEntityData.table)
      .order(GameTimeLogEntityData.gameField, GameTimeLogEntityData.table);

    addFields(query);
    GameQuery.addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(GameTimeLogEntityData.gameField, type: int, table: GameTimeLogEntityData.table);
    query.field(GameTimeLogEntityData.dateTimeField, type: DateTime, table: GameTimeLogEntityData.table);
  }

  static void _addIdWhere(GameTimeLogID id, Query query) {
    query.where(GameTimeLogEntityData.gameField, id.gameId, type: int, table: GameTimeLogEntityData.table);
    query.where(GameTimeLogEntityData.dateTimeField, id.dateTime, type: DateTime, table: GameTimeLogEntityData.table);
  }
}