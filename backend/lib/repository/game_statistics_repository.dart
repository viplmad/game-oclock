import 'package:query/query.dart' show Query;

import 'package:backend/connector/connector.dart' show ItemConnector;
import 'package:backend/entity/entity.dart' show GameEntityData, GameGeneralStatisticsEntity, GameStatisticsEntity, GameView, GameYearStatisticsEntity;

import './query/query.dart' show GameQuery;
import 'statistics_repository.dart';


class GameStatisticsRepository extends StatisticsRepository {
  GameStatisticsRepository(ItemConnector itemConnector) : super(itemConnector, recordName: GameEntityData.table);

  Future<GameGeneralStatisticsEntity> findGameStatistics(GameView view, int? year) async {
    final Query gameQuery = GameQuery.selectStatistics(view, year);
    final Map<String, Object?> gameMap = await readItemRaw(
      query: gameQuery,
    );

    final Query finishQuery = GameQuery.selectFinishStatistics(view, year);
    final Map<String, Object?> finishMap = await readItemRaw(
      query: finishQuery,
    );

    final Query timeLogQuery = GameQuery.selectTimeLogStatistics(view, year);
    final Map<String, Object?> timeLogMap = await readItemRaw(
      query: timeLogQuery,
    );

    final GameStatisticsEntity stats = GameStatisticsEntity.fromMap(gameMap, finishMap, timeLogMap);
    final int minReleaseYear = stats.minReleaseYear;
    final int maxReleaseYear = stats.maxReleaseYear;
    final int minFinishYear = stats.minFinishDate.year;
    final int maxFinishYear = stats.maxFinishDate.year;

    final Query countByReleaseYearQuery = GameQuery.selectStatisticsCountByReleaseYear(view, minReleaseYear, maxReleaseYear, year);
    final Map<String, Object?> countByReleaseYearMap = await readItemRaw(
      query: countByReleaseYearQuery,
    );

    final Query countByRatingQuery = GameQuery.selectStatisticsCountByRating(view, year);
    final Map<String, Object?> countByRatingMap = await readItemRaw(
      query: countByRatingQuery,
    );

    final Query averageRatingByFinishYearQuery = GameQuery.selectStatisticsAvgRatingByFinishYear(view, minFinishYear, maxFinishYear, year);
    final Map<String, Object?> averageRatingByFinishYearMap = await readItemRaw(
      query: averageRatingByFinishYearQuery,
    );

    final Query countByFinishYearQuery = GameQuery.selectStatisticsCountByFinishYear(view, minFinishYear, maxFinishYear, year);
    final Map<String, Object?> countByFinishYearMap = await readItemRaw(
      query: countByFinishYearQuery,
    );

    final Query logSumByFinishYearQuery = GameQuery.selectStatisticsSumTimeByFinishYear(view, minFinishYear, maxFinishYear, year);
    final Map<String, Object?> logSumByFinishYearMap = await readItemRaw(
      query: logSumByFinishYearQuery,
    );

    return GameGeneralStatisticsEntity.fromMap(stats, countByReleaseYearMap, countByRatingMap, averageRatingByFinishYearMap, countByFinishYearMap, logSumByFinishYearMap);
  }

  Future<GameYearStatisticsEntity> findGameStatisticsFinishYear(GameView view, int finishYear, int? year) async {
    final Query gameQuery = GameQuery.selectStatisticsWithFinishYear(view, finishYear, year);
    final Map<String, Object?> gameMap = await readItemRaw(
      query: gameQuery,
    );

    final Query finishQuery = GameQuery.selectFinishStatisticsWithFinishYear(view, finishYear, year);
    final Map<String, Object?> finishMap = await readItemRaw(
      query: finishQuery,
    );

    final Query timeLogQuery = GameQuery.selectTimeLogStatisticsWithFinishYear(view, finishYear, year);
    final Map<String, Object?> timeLogMap = await readItemRaw(
      query: timeLogQuery,
    );

    final GameStatisticsEntity stats = GameStatisticsEntity.fromMap(gameMap, finishMap, timeLogMap);
    final int minReleaseYear = stats.minReleaseYear;
    final int maxReleaseYear = stats.maxReleaseYear;

    final Query countByReleaseYearQuery = GameQuery.selectStatisticsCountByReleaseYearWithFinishYear(view, finishYear, minReleaseYear, maxReleaseYear, year);
    final Map<String, Object?> countByReleaseYearMap = await readItemRaw(
      query: countByReleaseYearQuery,
    );

    final Query countByRatingQuery = GameQuery.selectStatisticsCountByRatingWithFinishYear(view, finishYear, year);
    final Map<String, Object?> countByRatingMap = await readItemRaw(
      query: countByRatingQuery,
    );

    final Query timeLogSumByMonthQuery = GameQuery.selectStatisticsSumTimeByMonthWithFinishYear(view, finishYear, year);
    final Map<String, Object?> timeLogSumByMonthMap = await readItemRaw(
      query: timeLogSumByMonthQuery,
    );

    return GameYearStatisticsEntity.fromMap(stats, countByReleaseYearMap, countByRatingMap, timeLogSumByMonthMap);
  }
}