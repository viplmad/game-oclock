import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameFinishEntity, GameFinishEntityData;


class GameFinishQuery {
  GameFinishQuery._();

  static Query create(GameFinishEntity entity, int gameId) {
    final Query query = FluentQuery
      .insert()
      .into(GameFinishEntityData.table)
      .sets(entity.createMap(gameId));

    return query;
  }

  static Query deleteById(int gameId, DateTime date) {
    final Query query = FluentQuery
      .delete()
      .from(GameFinishEntityData.table);

    _addIdWhere(gameId, date, query);

    return query;
  }

  static Query selectAllByGame(int id) {
    final Query query = FluentQuery
      .select()
      .from(GameFinishEntityData.table)
      .where(GameFinishEntityData.gameField, id, type: int, table: GameFinishEntityData.table);

    addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(GameFinishEntityData.gameField, type: int, table: GameFinishEntityData.table);
    query.field(GameFinishEntityData.dateField, type: DateTime, table: GameFinishEntityData.table);
  }

  static void _addIdWhere(int gameId, DateTime date, Query query) {
    query.where(GameFinishEntityData.gameField, gameId, type: int, table: GameFinishEntityData.table);
    query.where(GameFinishEntityData.dateField, date, type: DateTime, table: GameFinishEntityData.table);
  }
}