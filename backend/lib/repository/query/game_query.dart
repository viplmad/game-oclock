import 'package:query/query.dart';

import 'package:backend/entity/entity.dart' show GameEntity, GameEntityData, GameFinishEntityData, GameID, GamePurchaseRelationData, GameStatisticsData, GameTimeLogEntityData, GameView;

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

  static Query selectStatistics(GameView view, [int? year]) {
    final Query query = FluentQuery
      .select()
      .field(GameEntityData.idField, type: int, table: GameEntityData.table, function: FunctionType.count, alias: GameStatisticsData.countField)
      .field(GameEntityData.ratingField, type: int, table: GameEntityData.table, function: FunctionType.sum, alias: GameStatisticsData.ratingSumField)
      .field(GameEntityData.releaseYearField, type: int, table: GameEntityData.table, function: FunctionType.min, alias: GameStatisticsData.minReleaseYearField)
      .field(GameEntityData.releaseYearField, type: int, table: GameEntityData.table, function: FunctionType.max, alias: GameStatisticsData.maxReleaseYearField)
      .fieldSubquery(_countStatusQuery(view, GameEntityData.lowPriorityValue, year), alias: GameStatisticsData.lowPriorityCountField)
      .fieldSubquery(_countStatusQuery(view, GameEntityData.nextUpValue, year), alias: GameStatisticsData.nextUpCountField)
      .fieldSubquery(_countStatusQuery(view, GameEntityData.playingValue, year), alias: GameStatisticsData.playingCountField)
      .fieldSubquery(_countStatusQuery(view, GameEntityData.playedValue, year), alias: GameStatisticsData.playedCountField)
      .from(GameEntityData.table);

    _completeView(query, view, year, skipOrder: true);

    return query;
  }

  static Query selectStatisticsWithFinishYear(GameView view, int finishYear, [int? year]) {
    final Query query = FluentQuery
      .select()
      .field(GameEntityData.idField, type: int, table: GameEntityData.table, function: FunctionType.count, alias: GameStatisticsData.countField)
      .field(GameEntityData.ratingField, type: int, table: GameEntityData.table, function: FunctionType.sum, alias: GameStatisticsData.ratingSumField)
      .field(GameEntityData.releaseYearField, type: int, table: GameEntityData.table, function: FunctionType.min, alias: GameStatisticsData.minReleaseYearField)
      .field(GameEntityData.releaseYearField, type: int, table: GameEntityData.table, function: FunctionType.max, alias: GameStatisticsData.maxReleaseYearField)
      .fieldSubquery(_countStatusQueryWithFinishYear(view, finishYear, GameEntityData.lowPriorityValue, year), alias: GameStatisticsData.lowPriorityCountField)
      .fieldSubquery(_countStatusQueryWithFinishYear(view, finishYear, GameEntityData.nextUpValue, year), alias: GameStatisticsData.nextUpCountField)
      .fieldSubquery(_countStatusQueryWithFinishYear(view, finishYear, GameEntityData.playingValue, year), alias: GameStatisticsData.playingCountField)
      .fieldSubquery(_countStatusQueryWithFinishYear(view, finishYear, GameEntityData.playedValue, year), alias: GameStatisticsData.playedCountField)
      .from(GameEntityData.table);

    _completeView(query, view, year, skipOrder: true);
    _filterByFinishYear(query, finishYear);

    return query;
  }

  static void _filterByFinishYear(Query query, int finishYear) {
    query.join(GameFinishEntityData.table, null, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField);
    query.whereDatePart(GameFinishEntityData.dateField, finishYear, DatePart.year, table: GameFinishEntityData.table, operator: OperatorType.eq);
  }

  static Query selectFinishStatistics(GameView view, [int? year]) {
    final Query query = FluentQuery
      .select()
      .field(GameFinishEntityData.gameField, type: int, table: GameFinishEntityData.table, function: FunctionType.count, alias: GameStatisticsData.finishCountField)
      .field(GameFinishEntityData.dateField, type: DateTime, table: GameFinishEntityData.table, function: FunctionType.min, alias: GameStatisticsData.minFinishDateField)
      .field(GameFinishEntityData.dateField, type: DateTime, table: GameFinishEntityData.table, function: FunctionType.max, alias: GameStatisticsData.maxFinishDateField)
      .from(GameFinishEntityData.table);

    query.join(GameEntityData.table, null, GameEntityData.idField, GameFinishEntityData.table, GameFinishEntityData.gameField);
    _completeView(query, view, year, skipOrder: true);

    return query;
  }

  static Query selectFinishStatisticsWithFinishYear(GameView view, int finishYear, [int? year]) {
    final Query query = selectFinishStatistics(view, year)
      // filter by finish year
      .whereDatePart(GameFinishEntityData.dateField, finishYear, DatePart.year, table: GameFinishEntityData.table, operator: OperatorType.eq);

    return query;
  }

  static Query selectTimeLogStatistics(GameView view, [int? year]) {
    final Query query = FluentQuery
      .select()
      .field(GameTimeLogEntityData.timeField, type: Duration, table: GameTimeLogEntityData.table, function: FunctionType.sum, alias: GameStatisticsData.timeLogSumField)
      .from(GameTimeLogEntityData.table);

    query.join(GameEntityData.table, null, GameEntityData.idField, GameTimeLogEntityData.table, GameTimeLogEntityData.gameField);
    _completeView(query, view, year, skipOrder: true);

    return query;
  }

  static Query selectTimeLogStatisticsWithFinishYear(GameView view, int finishYear, [int? year]) {
    final Query query = selectTimeLogStatistics(view, year)
      // filter by finish year
      .whereDatePart(GameTimeLogEntityData.dateTimeField, finishYear, DatePart.year, table: GameTimeLogEntityData.table, operator: OperatorType.eq);

    return query;
  }

  static Query selectStatisticsCountByReleaseYear(GameView view, int minReleaseYear, int maxReleaseYear, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    for (int releaseYear = minReleaseYear; releaseYear <= maxReleaseYear; releaseYear++) {
      final Query releaseYearCountQuery = FluentQuery
        .select()
        .field(GameEntityData.idField, type: int, table: GameEntityData.table, function: FunctionType.count)
        .from(GameEntityData.table)
        .where(GameEntityData.releaseYearField, releaseYear, type: int, table: GameEntityData.table, operator: OperatorType.eq);

      _completeView(releaseYearCountQuery, view, year, skipOrder: true);

      query.fieldSubquery(releaseYearCountQuery, alias: '$releaseYear');
    }

    return query;
  }

  static Query selectStatisticsCountByRating(GameView view, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    for (int rating = 1; rating <= 10; rating++) {
      final Query countQuery = FluentQuery
        .select()
        .field(GameEntityData.idField, type: int, table: GameEntityData.table, function: FunctionType.count)
        .from(GameEntityData.table)
        .where(GameEntityData.ratingField, rating, type: int, table: GameEntityData.table, operator: OperatorType.eq);

      _completeView(countQuery, view, year, skipOrder: true);

      query.fieldSubquery(countQuery, alias: '$rating');
    }

    return query;
  }

  static Query selectStatisticsAvgRatingByFinishYear(GameView view, int minFinishYear, int maxFinishYear, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    for(int finishYear = minFinishYear; finishYear <= maxFinishYear; finishYear++) {
      final Query ratingAvgQuery = FluentQuery
        .select()
        .field(GameEntityData.ratingField, type: double, table: GameEntityData.table, function: FunctionType.average)
        .from(GameEntityData.table)
        .join(GameFinishEntityData.table, null, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField)
        .whereDatePart(GameFinishEntityData.dateField, finishYear, DatePart.year, table: GameFinishEntityData.table, operator: OperatorType.eq);

      _completeView(ratingAvgQuery, view, year, skipOrder: true);

      query.fieldSubquery(ratingAvgQuery, alias: '$finishYear');
    }

    return query;
  }

  static Query selectStatisticsCountByFinishYear(GameView view, int minFinishYear, int maxFinishYear, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    for(int finishYear = minFinishYear; finishYear <= maxFinishYear; finishYear++) {
      final Query countQuery = FluentQuery
        .select()
        .field(GameEntityData.idField, type: int, table: GameEntityData.table, function: FunctionType.count)
        .from(GameEntityData.table)
        .join(GameFinishEntityData.table, null, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField)
        .whereDatePart(GameFinishEntityData.dateField, finishYear, DatePart.year, table: GameFinishEntityData.table, operator: OperatorType.eq);

      _completeView(countQuery, view, year, skipOrder: true);

      query.fieldSubquery(countQuery, alias: '$finishYear');
    }

    return query;
  }

  static Query selectStatisticsSumTimeByFinishYear(GameView view, int minFinishYear, int maxFinishYear, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    for(int finishYear = minFinishYear; finishYear <= maxFinishYear; finishYear++) {
      final Query timeSumQuery = FluentQuery
        .select()
        .field(GameTimeLogEntityData.timeField, type: Duration, table: GameTimeLogEntityData.table, function: FunctionType.sum)
        .from(GameTimeLogEntityData.table)
        .join(GameEntityData.table, null, GameEntityData.idField, GameTimeLogEntityData.table, GameTimeLogEntityData.gameField)
        .whereDatePart(GameTimeLogEntityData.dateTimeField, finishYear, DatePart.year, table: GameTimeLogEntityData.table, operator: OperatorType.eq);

      _completeView(timeSumQuery, view, year, skipOrder: true);

      query.fieldSubquery(timeSumQuery, alias: '$finishYear');
    }

    return query;
  }

  static Query selectStatisticsCountByRatingWithFinishYear(GameView view, int finishYear, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    for (int rating = 1; rating <= 10; rating++) {
      final Query countQuery = FluentQuery
        .select()
        .field(GameEntityData.idField, type: int, table: GameEntityData.table, function: FunctionType.count)
        .from(GameEntityData.table)
        .where(GameEntityData.ratingField, rating, type: int, table: GameEntityData.table, operator: OperatorType.eq);

      _completeView(countQuery, view, year, skipOrder: true);
      _filterByFinishYear(countQuery, finishYear);

      query.fieldSubquery(countQuery, alias: '$rating');
    }

    return query;
  }

  static Query selectStatisticsCountByReleaseYearWithFinishYear(GameView view, int finishYear, int minReleaseYear, int maxReleaseYear, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    for (int releaseYear = minReleaseYear; releaseYear <= maxReleaseYear; releaseYear++) {
      final Query releaseYearCountQuery = FluentQuery
        .select()
        .field(GameEntityData.idField, type: int, table: GameEntityData.table, function: FunctionType.count)
        .from(GameEntityData.table)
        .where(GameEntityData.releaseYearField, releaseYear, type: int, table: GameEntityData.table, operator: OperatorType.eq);

      _completeView(releaseYearCountQuery, view, year, skipOrder: true);
      _filterByFinishYear(releaseYearCountQuery, finishYear);

      query.fieldSubquery(releaseYearCountQuery, alias: '$releaseYear');
    }

    return query;
  }

  static Query selectStatisticsSumTimeByMonthWithFinishYear(GameView view, int finishYear, [int? year]) {
    final Query query = FluentQuery
      .select()
      .from(GameEntityData.table);

    for (int month = DateTime.january; month <= DateTime.monthsPerYear; month++) {
      final Query timeSumQuery = FluentQuery
        .select()
        .field(GameTimeLogEntityData.timeField, type: Duration, table: GameTimeLogEntityData.table, function: FunctionType.sum)
        .from(GameTimeLogEntityData.table)
        .join(GameEntityData.table, null, GameEntityData.idField, GameTimeLogEntityData.table, GameTimeLogEntityData.gameField)
        .whereDatePart(GameTimeLogEntityData.dateTimeField, month, DatePart.month, table: GameTimeLogEntityData.table, operator: OperatorType.eq)
        // filter by finish year
        .whereDatePart(GameTimeLogEntityData.dateTimeField, finishYear, DatePart.year, table: GameTimeLogEntityData.table, operator: OperatorType.eq);

        _completeView(timeSumQuery, view, year, skipOrder: true);

        query.fieldSubquery(timeSumQuery, alias: '$month');
    }

    return query;
  }

  static Query _countStatusQuery(GameView view, String status, [int? year]) {
    final Query query = FluentQuery
      .select()
      .field(GameEntityData.idField, type: int, table: GameEntityData.table, function: FunctionType.count)
      .from(GameEntityData.table)
      .where(GameEntityData.statusField, status, type: String, table: GameEntityData.table, operator: OperatorType.eq);

    _completeView(query, view, year, skipOrder: true);

    return query;
  }

  static Query _countStatusQueryWithFinishYear(GameView view, int finishYear, String status, [int? year]) {
    final Query query = _countStatusQuery(view, status, year);

    _filterByFinishYear(query, finishYear);

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

  static void _completeView(Query query, GameView view, int? year, {bool skipOrder = false}) {
    switch(view) {
      case GameView.main:
        if(!skipOrder) {
          query.order(GameEntityData.releaseYearField, GameEntityData.table);
          query.order(GameEntityData.nameField, GameEntityData.table);
        }
        break;
      case GameView.lastCreated:
        if(!skipOrder) {
          query.order(GameEntityData.idField, GameEntityData.table, direction: SortOrder.desc);
        }
        break;
      case GameView.playing:
        query.where(GameEntityData.statusField, GameEntityData.playingValue, table: GameEntityData.table);
        if(!skipOrder) {
          query.order(GameEntityData.releaseYearField, GameEntityData.table);
          query.order(GameEntityData.nameField, GameEntityData.table);
        }
        break;
      case GameView.nextUp:
        query.where(GameEntityData.statusField, GameEntityData.nextUpValue, table: GameEntityData.table);
        if(!skipOrder) {
          query.order(GameEntityData.releaseYearField, GameEntityData.table);
          query.order(GameEntityData.nameField, GameEntityData.table);
        }
        break;
      case GameView.lastPlayed:
        query.where(GameEntityData.statusField, GameEntityData.playingValue, table: GameEntityData.table, divider: DividerType.start);
        query.orWhere(GameEntityData.statusField, GameEntityData.playedValue, table: GameEntityData.table, divider: DividerType.end);

        if(!skipOrder) {
          final Query lastTimeLogQuery = FluentQuery
            .select()
            .field(GameTimeLogEntityData.dateTimeField, table: GameTimeLogEntityData.table, function: FunctionType.max)
            .from(GameTimeLogEntityData.table)
            .whereFields(GameTimeLogEntityData.table, GameTimeLogEntityData.gameField, GameEntityData.table, GameEntityData.idField);
          query.orderSubquery(lastTimeLogQuery, direction: SortOrder.desc, nullsLast: true);

          query.order(GameEntityData.nameField, GameEntityData.table);
        }
        break;
      case GameView.lastFinished:
        query.where(GameEntityData.statusField, GameEntityData.playingValue, table: GameEntityData.table, divider: DividerType.start);
        query.orWhere(GameEntityData.statusField, GameEntityData.playedValue, table: GameEntityData.table, divider: DividerType.end);

        if(!skipOrder) {
          final Query lastFinishQuery = FluentQuery
            .select()
            .field(GameFinishEntityData.dateField, table: GameFinishEntityData.table, function: FunctionType.max)
            .from(GameFinishEntityData.table)
            .whereFields(GameFinishEntityData.table, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField);
          query.orderSubquery(lastFinishQuery, direction: SortOrder.desc, nullsLast: true);

          query.order(GameEntityData.nameField, GameEntityData.table);
        }
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

        if(!skipOrder) {
          final Query firstFinishInYearQuery = FluentQuery
            .select()
            .field(GameFinishEntityData.dateField, table: GameFinishEntityData.table, function: FunctionType.min)
            .from(GameFinishEntityData.table)
            .whereFields(GameFinishEntityData.table, GameFinishEntityData.gameField, GameEntityData.table, GameEntityData.idField)
            .whereDatePart(GameFinishEntityData.dateField, year, DatePart.year, table: GameFinishEntityData.table);
          query.orderSubquery(firstFinishInYearQuery);

          query.order(GameEntityData.nameField, GameEntityData.table);
        }
        break;
    }
  }
}