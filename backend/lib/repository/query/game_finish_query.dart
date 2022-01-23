import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameFinishEntity, GameFinishEntityData, GameFinishID, GameID;


class GameFinishQuery {
  GameFinishQuery._();

  static Query create(GameFinishEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(GameFinishEntityData.table)
      .sets(entity.createMap())
      .returningField(GameFinishEntityData.gameField)
      .returningField(GameFinishEntityData.dateField);

    return query;
  }

  static Query updateById(GameFinishID id, GameFinishEntity entity, GameFinishEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(GameFinishEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(GameFinishID id) {
    final Query query = FluentQuery
      .delete()
      .from(GameFinishEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(GameFinishID id) {
    final Query query = FluentQuery
      .select()
      .from(GameFinishEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(GameFinishEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByGame(GameID id) {
    final Query query = FluentQuery
      .select()
      .from(GameFinishEntityData.table)
      .where(GameFinishEntityData.gameField, id.id, type: int, table: GameFinishEntityData.table);

    addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(GameFinishEntityData.gameField, type: int, table: GameFinishEntityData.table);
    query.field(GameFinishEntityData.dateField, type: DateTime, table: GameFinishEntityData.table);
  }

  static void _addIdWhere(GameFinishID id, Query query) {
    query.where(GameFinishEntityData.gameField, id.gameId.id, type: int, table: GameFinishEntityData.table);
    query.where(GameFinishEntityData.dateField, id.dateTime, type: DateTime, table: GameFinishEntityData.table);
  }
}