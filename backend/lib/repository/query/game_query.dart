import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameEntity, GameEntityData;
import 'package:backend/model/model.dart' show GameView;


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

  static Query updateById(int id, GameEntity entity, GameEntity updatedEntity) {
    final Query query = FluentQuery
      .update()
      .table(GameEntityData.table)
      .sets(entity.updateMap(updatedEntity));

    _addIdWhere(id, query);

    return query;
  }

  static Query updateCoverById(int id, String? coverName) {
    final Query query = FluentQuery
      .update()
      .table(GameEntityData.table)
      .set(GameEntityData.coverField, coverName);

    _addIdWhere(id, query);

    return query;
  }

  static Query deleteById(int id) {
    final Query query = FluentQuery
      .delete()
      .from(GameEntityData.table);

    _addIdWhere(id, query);

    return query;
  }

  static Query selectById(int id) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    addFields(query);
    _addIdWhere(id, query);

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
      .from(GameEntityData.table)
      .limit(limit);

    addFields(query);
    _addViewWhere(query, view, year);
    _addViewOrder(query, view);

    return query;
  }

  static Query selectAllInViewAndOwned(GameView view, [int? limit, int? year]) {
    final Query query = selectAllInView(view, limit, year);
    // TODO subquery to cross with purchases
    return query;
  }

  static Query selectAllInViewAndRom(GameView view, [int? limit, int? year]) {
    final Query query = selectAllInView(view, limit, year);
    // TODO subquery to cross with purchases
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
    query.field(GameEntityData.timeField, type: Duration, table: GameEntityData.table);
    query.field(GameEntityData.saveFolderField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.screenshotFolderField, type: String, table: GameEntityData.table);
    query.field(GameEntityData.finishDateField, type: DateTime, table: GameEntityData.table);
    query.field(GameEntityData.backupField, type: bool, table: GameEntityData.table);
  }

  static void _addIdWhere(int id, Query query) {
    query.where(GameEntityData.idField, id, type: int, table: GameEntityData.table);
  }

  static void _addViewWhere(Query query, GameView view, [int? year]) {
    switch(view) {
      case GameView.Main:
        break;
      case GameView.LastCreated:
        break;
      case GameView.Playing:
        query.where(GameEntityData.statusField, '\'Playing\'::game_status', table: GameEntityData.table);
        break;
      case GameView.NextUp:
        query.where(GameEntityData.statusField, '\'Next Up\'::game_status', table: GameEntityData.table);
        break;
      case GameView.LastPlayed:
      case GameView.LastFinished:
        query.where(GameEntityData.statusField, '\'Playing\'::game_status', table: GameEntityData.table);
        query.where(GameEntityData.statusField, '\'Played\'::game_status', table: GameEntityData.table);
        break;
      case GameView.Review:
        year = year?? DateTime.now().year;
        query.whereDatePart(GameEntityData.finishDateField, year, DatePart.YEAR, table: GameEntityData.table);
        break;
    }
  }

  static void _addViewOrder(Query query, GameView view) {
    switch(view) {
      case GameView.Main:
        break;
      case GameView.LastCreated:
        query.order(GameEntityData.idField, GameEntityData.table, direction: SortOrder.DESC);
        break;
      case GameView.Playing:
        break;
      case GameView.NextUp:
        break;
      case GameView.LastPlayed:
        break;
      case GameView.LastFinished:
        break;
      case GameView.Review:
        break;
    }
  }
}