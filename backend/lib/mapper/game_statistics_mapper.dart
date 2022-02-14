import 'package:backend/entity/entity.dart'
    show GameGeneralStatisticsEntity, GameYearStatisticsEntity;
import 'package:backend/model/model.dart'
    show GameGeneralStatistics, GameYearStatistics;

class GameStatisticsMapper {
  GameStatisticsMapper._();

  static GameGeneralStatistics generalEntityToModel(
    GameGeneralStatisticsEntity entity,
  ) {
    return GameGeneralStatistics(
      total: entity.count,
      ratingSum: entity.ratingSum,
      minReleaseYear: entity.minReleaseYear,
      maxReleaseYear: entity.maxReleaseYear,
      lowPriorityCount: entity.lowPriorityCount,
      nextUpCount: entity.nextUpCount,
      playingCount: entity.playingCount,
      playedCount: entity.playedCount,
      finishCount: entity.finishCount,
      minFinishDate: entity.minFinishDate,
      maxFinishDate: entity.maxFinishDate,
      timeLogSum: entity.timeLogSum,
      countByReleaseYear: entity.countByReleaseYear,
      countByRating: entity.countByRating,
      avgRatingByFinishYear: entity.avgRatingByFinishYear,
      countByFinishYear: entity.countByFinishYear,
      totalTimeByFinishYear: entity.timeLogSumByFinishYear,
    );
  }

  static GameYearStatistics yearEntityToModel(GameYearStatisticsEntity entity) {
    return GameYearStatistics(
      total: entity.count,
      ratingSum: entity.ratingSum,
      minReleaseYear: entity.minReleaseYear,
      maxReleaseYear: entity.maxReleaseYear,
      lowPriorityCount: entity.lowPriorityCount,
      nextUpCount: entity.nextUpCount,
      playingCount: entity.playingCount,
      playedCount: entity.playedCount,
      finishCount: entity.finishCount,
      minFinishDate: entity.minFinishDate,
      maxFinishDate: entity.maxFinishDate,
      timeLogSum: entity.timeLogSum,
      countByReleaseYear: entity.countByReleaseYear,
      countByRating: entity.countByRating,
      totalTimeByMonth: entity.timeLogSumByMonth,
    );
  }

  static Future<GameGeneralStatistics> futureGeneralEntityToModel(
    Future<GameGeneralStatisticsEntity> entityFuture,
  ) {
    return entityFuture.asStream().map(generalEntityToModel).first;
  }

  static Future<GameYearStatistics> futureYearEntityToModel(
    Future<GameYearStatisticsEntity> entityFuture,
  ) {
    return entityFuture.asStream().map(yearEntityToModel).first;
  }
}
