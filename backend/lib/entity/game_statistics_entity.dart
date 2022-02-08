import 'package:equatable/equatable.dart';

import 'entity.dart' show GameEntityData, GameFinishEntityData, GameTimeLogEntityData;


class GameStatisticsData {
  GameStatisticsData._();

  static const String countField = 'count';
  static const String ratingSumField = 'avg' + GameEntityData.ratingField;
  static const String minReleaseYearField = 'min' + GameEntityData.releaseYearField;
  static const String maxReleaseYearField = 'max' + GameEntityData.releaseYearField;
  static const String lowPriorityCountField = 'count' + GameEntityData.lowPriorityValue;
  static const String nextUpCountField = 'count' + GameEntityData.nextUpValue;
  static const String playingCountField = 'count' + GameEntityData.playingValue;
  static const String playedCountField = 'count' + GameEntityData.playedValue;

  static const String finishCountField = GameStatisticsData.countField;
  static const String minFinishDateField = 'min' + GameFinishEntityData.dateField;
  static const String maxFinishDateField = 'max' + GameFinishEntityData.dateField;

  static const String timeLogSumField = 'sum' + GameTimeLogEntityData.timeField;
}

class GameStatisticsEntity extends Equatable {
  const GameStatisticsEntity({
    required this.count,
    required this.ratingSum,
    required this.minReleaseYear,
    required this.maxReleaseYear,
    required this.lowPriorityCount,
    required this.nextUpCount,
    required this.playingCount,
    required this.playedCount,
    required this.finishCount,
    required this.minFinishDate,
    required this.maxFinishDate,
    required this.timeLogSum,
  });

  final int count;
  final int ratingSum;
  final int minReleaseYear;
  final int maxReleaseYear;
  final int lowPriorityCount;
  final int nextUpCount;
  final int playingCount;
  final int playedCount;
  final int finishCount;
  final DateTime minFinishDate;
  final DateTime maxFinishDate;
  final Duration timeLogSum;

  static GameStatisticsEntity fromMap(Map<String, Object?> map, Map<String, Object?> finishMap, Map<String, Object?> timeLogMap) {

    return GameStatisticsEntity(
      count: (map[GameStatisticsData.countField] as int?)?? 0,
      ratingSum: (map[GameStatisticsData.ratingSumField] as int?)?? 0,
      minReleaseYear: (map[GameStatisticsData.minReleaseYearField] as int?)?? 0,
      maxReleaseYear: (map[GameStatisticsData.maxReleaseYearField] as int?)?? 0,
      lowPriorityCount: (map[GameStatisticsData.lowPriorityCountField] as int?)?? 0,
      nextUpCount: (map[GameStatisticsData.nextUpCountField] as int?)?? 0,
      playingCount: (map[GameStatisticsData.playingCountField] as int?)?? 0,
      playedCount: (map[GameStatisticsData.playedCountField] as int?)?? 0,
      finishCount: (finishMap[GameStatisticsData.finishCountField] as int?)?? 0,
      minFinishDate: (finishMap[GameStatisticsData.minFinishDateField] as DateTime?)?? DateTime.now(),
      maxFinishDate: (finishMap[GameStatisticsData.maxFinishDateField] as DateTime?)?? DateTime.now(),
      timeLogSum: (timeLogMap[GameStatisticsData.timeLogSumField] as Duration?)?? const Duration(),
    );

  }

  static Map<int, T> mapToYearMap<T>(Map<String, Object?> map, T valueIfNull) {
    return map.map<int, T>((String key, Object? value) => MapEntry<int, T>(int.parse(key), (value as T?)?? valueIfNull));
  }

  @override
  List<Object> get props => <Object>[
    count,
    ratingSum,
    lowPriorityCount,
    nextUpCount,
    playingCount,
    playedCount,
    finishCount,
    timeLogSum,
  ];

  @override
  String toString() {

    return 'GameStatisticsEntity { '
        '${GameStatisticsData.countField}: $count, '
        '${GameStatisticsData.ratingSumField}: $ratingSum, '
        '${GameStatisticsData.lowPriorityCountField}: $lowPriorityCount, '
        '${GameStatisticsData.nextUpCountField}: $nextUpCount, '
        '${GameStatisticsData.playingCountField}: $playingCount, '
        '${GameStatisticsData.playedCountField}: $playedCount, '
        '${GameStatisticsData.finishCountField}: $finishCount, '
        '${GameStatisticsData.timeLogSumField}: $timeLogSum'
        ' }';

  }
}

class GameGeneralStatisticsEntity extends GameStatisticsEntity {
  const GameGeneralStatisticsEntity({
    required int count,
    required int ratingSum,
    required int minReleaseYear,
    required int maxReleaseYear,
    required int lowPriorityCount,
    required int nextUpCount,
    required int playingCount,
    required int playedCount,
    required int finishCount,
    required DateTime minFinishDate,
    required DateTime maxFinishDate,
    required Duration timeLogSum,
    required this.countByReleaseYear,
    required this.countByRating,
    required this.avgRatingByFinishYear,
    required this.countByFinishYear,
    required this.timeLogSumByFinishYear,
  }) : super(
    count: count,
    ratingSum: ratingSum,
    minReleaseYear: minReleaseYear,
    maxReleaseYear: maxReleaseYear,
    lowPriorityCount: lowPriorityCount,
    nextUpCount: nextUpCount,
    playingCount: playingCount,
    playedCount: playedCount,
    finishCount: finishCount,
    minFinishDate: minFinishDate,
    maxFinishDate: maxFinishDate,
    timeLogSum: timeLogSum,
  );

  final Map<int, int> countByReleaseYear;
  final Map<int, int> countByRating;
  final Map<int, double> avgRatingByFinishYear;
  final Map<int, int> countByFinishYear;
  final Map<int, Duration> timeLogSumByFinishYear;

  static GameGeneralStatisticsEntity fromMap(GameStatisticsEntity stats, Map<String, Object?> countByReleaseYearMap, Map<String, Object?> countByRatingMap, Map<String, Object?> avgRatingByFinishYearMap, Map<String, Object?> countByFinishYearMap, Map<String, Object?> timeLogSumByFinishYearMap) {

    return GameGeneralStatisticsEntity(
      count: stats.count,
      ratingSum: stats.ratingSum,
      minReleaseYear: stats.minReleaseYear,
      maxReleaseYear: stats.maxReleaseYear,
      lowPriorityCount: stats.lowPriorityCount,
      nextUpCount: stats.nextUpCount,
      playingCount: stats.playingCount,
      playedCount: stats.playedCount,
      finishCount: stats.ratingSum,
      minFinishDate: stats.minFinishDate,
      maxFinishDate: stats.maxFinishDate,
      timeLogSum: stats.timeLogSum,
      countByReleaseYear: GameStatisticsEntity.mapToYearMap<int>(countByReleaseYearMap, 0),
      countByRating: GameStatisticsEntity.mapToYearMap<int>(countByRatingMap, 0),
      avgRatingByFinishYear: GameStatisticsEntity.mapToYearMap<double>(avgRatingByFinishYearMap, 0.0),
      countByFinishYear: GameStatisticsEntity.mapToYearMap<int>(countByFinishYearMap, 0),
      timeLogSumByFinishYear: GameStatisticsEntity.mapToYearMap<Duration>(timeLogSumByFinishYearMap, Duration.zero),
    );

  }

  @override
  List<Object> get props => <Object>[
    count,
    ratingSum,
    lowPriorityCount,
    nextUpCount,
    playingCount,
    playedCount,
    finishCount,
    timeLogSum,
    countByReleaseYear,
    countByRating,
    avgRatingByFinishYear,
    countByFinishYear,
    timeLogSumByFinishYear,
  ];

  @override
  String toString() {

    return 'GameGeneralStatisticsEntity { '
        '${GameStatisticsData.countField}: $count, '
        '${GameStatisticsData.ratingSumField}: $ratingSum, '
        '${GameStatisticsData.lowPriorityCountField}: $lowPriorityCount, '
        '${GameStatisticsData.nextUpCountField}: $nextUpCount, '
        '${GameStatisticsData.playingCountField}: $playingCount, '
        '${GameStatisticsData.playedCountField}: $playedCount, '
        '${GameStatisticsData.finishCountField}: $finishCount, '
        '${GameStatisticsData.timeLogSumField}: $timeLogSum, '
        'countByReleaseYear: $countByReleaseYear, '
        'countByRating: $countByRating, '
        'avgRatingByFinishYear: $avgRatingByFinishYear, '
        'countByFinishYear: $countByFinishYear, '
        'timeLogSumByFinishYear: $timeLogSumByFinishYear'
        ' }';

  }
}

class GameYearStatisticsEntity extends GameStatisticsEntity {
  const GameYearStatisticsEntity({
    required int count,
    required int ratingSum,
    required int minReleaseYear,
    required int maxReleaseYear,
    required int lowPriorityCount,
    required int nextUpCount,
    required int playingCount,
    required int playedCount,
    required int finishCount,
    required DateTime minFinishDate,
    required DateTime maxFinishDate,
    required Duration timeLogSum,
    required this.countByReleaseYear,
    required this.countByRating,
    required this.timeLogSumByMonth,
  }) : super(
    count: count,
    ratingSum: ratingSum,
    minReleaseYear: minReleaseYear,
    maxReleaseYear: maxReleaseYear,
    lowPriorityCount: lowPriorityCount,
    nextUpCount: nextUpCount,
    playingCount: playingCount,
    playedCount: playedCount,
    finishCount: finishCount,
    minFinishDate: minFinishDate,
    maxFinishDate: maxFinishDate,
    timeLogSum: timeLogSum,
  );

  final Map<int, int> countByReleaseYear;
  final Map<int, int> countByRating;
  final Map<int, Duration> timeLogSumByMonth;

  static GameYearStatisticsEntity fromMap(GameStatisticsEntity stats, Map<String, Object?> countByReleaseYearMap, Map<String, Object?> countByRatingMap, Map<String, Object?> timeLogSumByMonthMap) {

    return GameYearStatisticsEntity(
      count: stats.count,
      ratingSum: stats.ratingSum,
      minReleaseYear: stats.minReleaseYear,
      maxReleaseYear: stats.maxReleaseYear,
      lowPriorityCount: stats.lowPriorityCount,
      nextUpCount: stats.nextUpCount,
      playingCount: stats.playingCount,
      playedCount: stats.playedCount,
      finishCount: stats.ratingSum,
      minFinishDate: stats.minFinishDate,
      maxFinishDate: stats.maxFinishDate,
      timeLogSum: stats.timeLogSum,
      countByReleaseYear: GameStatisticsEntity.mapToYearMap<int>(countByReleaseYearMap, 0),
      countByRating: GameStatisticsEntity.mapToYearMap<int>(countByRatingMap, 0),
      timeLogSumByMonth: GameStatisticsEntity.mapToYearMap<Duration>(timeLogSumByMonthMap, Duration.zero),
    );

  }

  @override
  List<Object> get props => <Object>[
    count,
    ratingSum,
    lowPriorityCount,
    nextUpCount,
    playingCount,
    playedCount,
    finishCount,
    timeLogSum,
    countByReleaseYear,
    countByRating,
    timeLogSumByMonth,
  ];

  @override
  String toString() {

    return 'GameYearStatisticsEntity { '
        '${GameStatisticsData.countField}: $count, '
        '${GameStatisticsData.ratingSumField}: $ratingSum, '
        '${GameStatisticsData.lowPriorityCountField}: $lowPriorityCount, '
        '${GameStatisticsData.nextUpCountField}: $nextUpCount, '
        '${GameStatisticsData.playingCountField}: $playingCount, '
        '${GameStatisticsData.playedCountField}: $playedCount, '
        '${GameStatisticsData.finishCountField}: $finishCount, '
        '${GameStatisticsData.timeLogSumField}: $timeLogSum, '
        'countByReleaseYear: $countByReleaseYear, '
        'countByRating: $countByRating, '
        'timeLogSumByMonth: $timeLogSumByMonth'
        ' }';

  }
}