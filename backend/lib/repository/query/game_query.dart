import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameEntity, GameEntityData, GameFinishEntityData, GameID, GamePurchaseRelationData, GameTimeLogEntityData, GameView;

import 'query_utils.dart';


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

  static Query selectAll([int? page]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    addFields(query);
    QueryUtils.paginate(query, page);

    return query;
  }

  static Query selectAllInView(GameView view, [int? year, int? page]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    addFields(query);
    _completeView(query, view, year);
    QueryUtils.paginate(query, page);

    return query;
  }

  static Query selectFirstInView(GameView view, int limit, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .limit(limit);

    addFields(query);
    _completeView(query, view, year);

    return query;
  }

  static Query selectAllOwnedInView(GameView view, [int? year, int? page]) {
    final Query query = selectAllInView(view, year, page);

    final Query countGamePurchaseQuery = FluentQuery
      .select()
      .field(GamePurchaseRelationData.gameField, type: int, table: GamePurchaseRelationData.table, function: FunctionType.count)
      .from(GamePurchaseRelationData.table)
      .whereFields(GamePurchaseRelationData.table, GamePurchaseRelationData.gameField, GameEntityData.table, GameEntityData.idField);
    query.whereSubquery(countGamePurchaseQuery, 0, operator: OperatorType.greaterThan);

    return query;
  }

  static Query selectAllRomInView(GameView view, [int? year, int? page]) {
    final Query query = selectAllInView(view, year, page);

    final Query countGamePurchaseQuery = FluentQuery
      .select()
      .field(GamePurchaseRelationData.gameField, type: int, table: GamePurchaseRelationData.table, function: FunctionType.count)
      .from(GamePurchaseRelationData.table)
      .whereFields(GamePurchaseRelationData.table, GamePurchaseRelationData.gameField, GameEntityData.table, GameEntityData.idField);
    query.whereSubquery(countGamePurchaseQuery, 0);

    return query;
  }

  static Query selectFirstByNameLike(String name, int limit) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .where(GameEntityData.nameField, name, type: String, table: GameEntityData.table, operator: OperatorType.like)
      .limit(limit);

    addFields(query);

    return query;
  }

  static Query selectFirstInViewByNameLike(GameView view, String name, int limit, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table)
      .limit(limit);

    addFields(query);
    _completeView(query, view, year);
    query.where(GameEntityData.nameField, name, type: String, table: GameEntityData.table, operator: OperatorType.like);

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
    query.field(GameEntityData.saveFolderField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.screenshotFolderField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.backupField, type: bool, table: GameEntityData.table);

    final Query firstFinishQuery = FluentQuery
      .select()
      .field(GameFinishEntityData.dateField, type: DateTime, table: GameFinishEntityData.table, function: FunctionType.min)
      .from(GameFinishEntityData.table)
      .whereFields(GameFinishEntityData.table, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField);
    query.fieldSubquery(firstFinishQuery, alias: GameEntityData.firstFinishDateField);

    final Query totalTimeQuery = FluentQuery
      .select()
      .field(GameTimeLogEntityData.timeField, type: Duration, table: GameTimeLogEntityData.table, function: FunctionType.sum)
      .from(GameTimeLogEntityData.table)
      .whereFields(GameTimeLogEntityData.table, GameTimeLogEntityData.gameField, GameEntityData.table, GameEntityData.idField);
    query.fieldSubquery(totalTimeQuery, alias: GameEntityData.totalTimeField);
  }

  static void _addIdWhere(GameID id, Query query) {
    query.where(GameEntityData.idField, id.id, type: int, table: GameEntityData.table);
  }

  static void _completeView(Query query, GameView view, int? year) {
    switch(view) {
      case GameView.main:
        query.order(GameEntityData.releaseYearField, GameEntityData.table);
        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
      case GameView.lastCreated:
        query.order(GameEntityData.idField, GameEntityData.table, direction: SortOrder.desc);
        break;
      case GameView.playing:
        query.where(GameEntityData.statusField, GameEntityData.playingValue, table: GameEntityData.table);
        query.order(GameEntityData.releaseYearField, GameEntityData.table);
        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
      case GameView.nextUp:
        query.where(GameEntityData.statusField, GameEntityData.nextUpValue, table: GameEntityData.table);
        query.order(GameEntityData.releaseYearField, GameEntityData.table);
        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
      case GameView.lastPlayed:
        query.where(GameEntityData.statusField, GameEntityData.playingValue, table: GameEntityData.table, divider: DividerType.start);
        query.orWhere(GameEntityData.statusField, GameEntityData.playedValue, table: GameEntityData.table, divider: DividerType.end);

        final Query lastTimeLogQuery = FluentQuery
          .select()
          .field(GameTimeLogEntityData.dateTimeField, table: GameTimeLogEntityData.table, function: FunctionType.max)
          .from(GameTimeLogEntityData.table)
          .whereFields(GameTimeLogEntityData.table, GameTimeLogEntityData.gameField, GameEntityData.table, GameEntityData.idField);
        query.orderSubquery(lastTimeLogQuery, direction: SortOrder.desc, nullsLast: true);

        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
      case GameView.lastFinished:
        query.where(GameEntityData.statusField, GameEntityData.playingValue, table: GameEntityData.table, divider: DividerType.start);
        query.orWhere(GameEntityData.statusField, GameEntityData.playedValue, table: GameEntityData.table, divider: DividerType.end);

        final Query lastFinishQuery = FluentQuery
          .select()
          .field(GameFinishEntityData.dateField, table: GameFinishEntityData.table, function: FunctionType.max)
          .from(GameFinishEntityData.table)
          .whereFields(GameFinishEntityData.table, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField);
        query.orderSubquery(lastFinishQuery, direction: SortOrder.desc, nullsLast: true);

        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
      case GameView.review:
        year = year?? DateTime.now().year;

        final Query finishCountInYearQuery = FluentQuery
          .select()
          .field(GameFinishEntityData.gameField, table: GameFinishEntityData.table, function: FunctionType.count)
          .from(GameFinishEntityData.table)
          .whereFields(GameFinishEntityData.table, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField)
          .whereDatePart(GameFinishEntityData.dateField, year, DatePart.year, table: GameFinishEntityData.table);
        query.whereSubquery(finishCountInYearQuery, 0, operator: OperatorType.greaterThan);

        final Query firstFinishInYearQuery = FluentQuery
          .select()
          .field(GameFinishEntityData.dateField, table: GameFinishEntityData.table, function: FunctionType.min)
          .from(GameFinishEntityData.table)
          .whereFields(GameFinishEntityData.table, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField)
          .whereDatePart(GameFinishEntityData.dateField, year, DatePart.year, table: GameFinishEntityData.table);
        query.orderSubquery(firstFinishInYearQuery);

        query.order(GameEntityData.nameField, GameEntityData.table);
        break;
    }
  }
}