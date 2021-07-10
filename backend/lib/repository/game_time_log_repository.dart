import 'package:backend/repository/game_repository.dart';
import 'package:query/query.dart';

import 'package:backend/entity/entity.dart';


class GameTimeLogRepository {
  GameTimeLogRepository._();

  static Query create(GameTimeLogEntity entity, int gameId) {
    final Query query = FluentQuery
      .insert()
      .into(GameTimeLogEntityData.table)
      .sets(entity.createMap(gameId));

    return query;
  }

  static Query deleteById(int gameId, DateTime dateTime) {
    final Query query = FluentQuery
      .delete()
      .from(GameTimeLogEntityData.table);

    _addIdWhere(gameId, dateTime, query);

    return query;
  }

  static Query selectAllByGame(int id) {
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
    GameRepository.addFields(query);

    return query;
  }

  static void addFields(Query query) {
    query.field(GameTimeLogEntityData.gameField, type: int, table: GameTimeLogEntityData.table);
    query.field(GameTimeLogEntityData.dateTimeField, type: DateTime, table: GameTimeLogEntityData.table);
  }

  static void _addIdWhere(int gameId, DateTime dateTime, Query query) {
    query.where(GameTimeLogEntityData.gameField, gameId, type: int, table: GameTimeLogEntityData.table);
    query.where(GameTimeLogEntityData.dateTimeField, dateTime, type: DateTime, table: GameTimeLogEntityData.table);
  }
}