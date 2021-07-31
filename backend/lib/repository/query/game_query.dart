import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameEntity, GameEntityData, GameFinishEntityData, GameID, GamePurchaseRelationData, GameTimeLogEntityData, GameView, nextUpValue, playingValue, playedValue;


class GameQuery {
  GameQuery._();

  static Query create(GameEntity entity) {
    final Query query = FluentQuery
      .insert()
      .into(GameEntityData.table)
      .sets(entity.createMap())
      .returningField(GameEntityData.idField);

    return query;
  }

  static Query updateById(GameID id, GameEntity entity, GameEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(GameEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateCoverById(GameID id, String? coverName) {
    final Query query = FluentQuery
      .update()
      .table(GameEntityData.table)
      .set(GameEntityData.coverField, coverName);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(GameID id) {
    final Query query = FluentQuery
      .delete()
      .from(GameEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(GameID id) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

    return query;
  }

  static Query selectAll() {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    addFields(query);

    return query;
  }

  static Query selectAllByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .where(GameEntityData.nameField, name, type: String, table: GameEntityData.table, operator: OperatorType.LIKE)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectAllInView(GameView view, [int? limit, int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    addFields(query);
    _completeView(query, view, limit, year);

    return query;
  }

  static Query selectAllOwnedInView(GameView view, [int? limit, int? year]) {
    final Query query = selectAllInView(view, limit, year);

    final Query countGamePurchaseQuery = FluentQuery
      .select()
      .field(GamePurchaseRelationData.gameField, type: int, table: GamePurchaseRelationData.table, function: FunctionType.COUNT)
      .from(GamePurchaseRelationData.table)
      .whereFields(GamePurchaseRelationData.table, GamePurchaseRelationData.gameField, GameEntityData.table, GameEntityData.idField);
    query.whereSubquery(countGamePurchaseQuery, 0, operator: OperatorType.GREATER_THAN);

    return query;
  }

  static Query selectAllRomInView(GameView view, [int? limit, int? year]) {
    final Query query = selectAllInView(view, limit, year);

    final Query countGamePurchaseQuery = FluentQuery
      .select()
      .field(GamePurchaseRelationData.gameField, type: int, table: GamePurchaseRelationData.table, function: FunctionType.COUNT)
      .from(GamePurchaseRelationData.table)
      .whereFields(GamePurchaseRelationData.table, GamePurchaseRelationData.gameField, GameEntityData.table, GameEntityData.idField);
    query.whereSubquery(countGamePurchaseQuery, 0);

    return query;
  }

  static void addFields(Query query) {
    query.field(GameEntityData.idField, type: int, table: GameEntityData.table);
    query.field(GameEntityData.nameField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.editionField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.releaseYearField, type: int, table: GameEntityData.table);
    query.field(GameEntityData.coverField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.statusField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.ratingField, type: int, table: GameEntityData.table);
    query.field(GameEntityData.thoughtsField, type: String, table: GameEntityData.table);

    final Query totalTimeQuery = FluentQuery
      .select()
      .field(GameTimeLogEntityData.timeField, type: Duration, table: GameTimeLogEntityData.table, function: FunctionType.SUM)
      .from(GameTimeLogEntityData.table)
      .whereFields(GameTimeLogEntityData.table, GameTimeLogEntityData.gameField, GameEntityData.table, GameEntityData.idField);
    query.fieldSubquery(totalTimeQuery, alias: GameEntityData.timeField);

    query.field(GameEntityData.saveFolderField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.screenshotFolderField, type: String, table: GameEntityData.table);

    final Query firstFinishQuery = FluentQuery
      .select()
      .field(GameFinishEntityData.dateField, type: DateTime, table: GameFinishEntityData.table, function: FunctionType.MIN)
      .from(GameFinishEntityData.table)
      .whereFields(GameFinishEntityData.table, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField);
    query.fieldSubquery(firstFinishQuery, alias: GameEntityData.finishDateField);

    query.field(GameEntityData.backupField, type: bool, table: GameEntityData.table);
  }

  static void _addIdWhere(GameID id, Query query) {
    query.where(GameEntityData.idField, id.id, type: int, table: GameEntityData.table);
  }

  static void _completeView(Query query, GameView view, int? limit, int? year) {
    switch(view) {
      case GameView.Main:
        query.order(GameEntityData.releaseYearField, GameEntityData.table);
        query.order(GameEntityData.nameField, GameEntityData.table);
        query.limit(limit);
        break;
      case GameView.LastCreated:
        query.order(GameEntityData.idField, GameEntityData.table, direction: SortOrder.DESC);
        query.limit(limit?? 50);
        break;
      case GameView.Playing:
        query.where(GameEntityData.statusField, '\'$playingValue\'::game_status', table: GameEntityData.table);
        query.order(GameEntityData.releaseYearField, GameEntityData.table);
        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
      case GameView.NextUp:
        query.where(GameEntityData.statusField, '\'$nextUpValue\'::game_status', table: GameEntityData.table);
        query.order(GameEntityData.releaseYearField, GameEntityData.table);
        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
      case GameView.LastPlayed:
        query.where(GameEntityData.statusField, '\'$playingValue\'::game_status', table: GameEntityData.table);
        query.orWhere(GameEntityData.statusField, '\'$playedValue\'::game_status', table: GameEntityData.table);

        final Query lastTimeLogQuery = FluentQuery
          .select()
          .field(GameTimeLogEntityData.dateTimeField, type: Duration, table: GameTimeLogEntityData.table, function: FunctionType.MAX)
          .from(GameTimeLogEntityData.table)
          .whereFields(GameTimeLogEntityData.table, GameTimeLogEntityData.gameField, GameEntityData.table, GameEntityData.idField);
        query.orderSubquery(lastTimeLogQuery, direction: SortOrder.DESC, nullsLast: true);

        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
      case GameView.LastFinished:
        query.where(GameEntityData.statusField, '\'$playingValue\'::game_status', table: GameEntityData.table);
        query.orWhere(GameEntityData.statusField, '\'$playedValue\'::game_status', table: GameEntityData.table);

        final Query lastFinishQuery = FluentQuery
          .select()
          .field(GameFinishEntityData.dateField, type: DateTime, table: GameFinishEntityData.table, function: FunctionType.MAX)
          .from(GameFinishEntityData.table)
          .whereFields(GameFinishEntityData.table, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField);
        query.orderSubquery(lastFinishQuery, direction: SortOrder.DESC, nullsLast: true);

        query.order(GameEntityData.nameField, GameEntityData.table);
        query.limit(limit?? 100);
        break;
      case GameView.Review:
        year = year?? DateTime.now().year;

        final Query finishCountInYearQuery = FluentQuery
          .select()
          .field(GameFinishEntityData.gameField, type: int, table: GameFinishEntityData.table, function: FunctionType.COUNT)
          .from(GameFinishEntityData.table)
          .whereDatePart(GameFinishEntityData.dateField, year, DatePart.YEAR, table: GameFinishEntityData.table);
        query.whereSubquery(finishCountInYearQuery, 0, operator: OperatorType.GREATER_THAN);

        query.order(GameEntityData.finishDateField, GameEntityData.table);
        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
    }
  }
}