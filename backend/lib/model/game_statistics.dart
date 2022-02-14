import 'model.dart';

abstract class _GameStatistics extends ItemStatistics {
  const _GameStatistics({
    required this.total,
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
    required this.totalTime,
  }) : super();

  final int total;
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
  final Duration totalTime;
}

class GameGeneralStatistics extends _GameStatistics {
  const GameGeneralStatistics({
    required int total,
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
    required this.totalTimeByFinishYear,
  }) : super(
          total: total,
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
          totalTime: timeLogSum,
        );

  final Map<int, int> countByReleaseYear;
  final Map<int, int> countByRating;
  final Map<int, double> avgRatingByFinishYear;
  final Map<int, int> countByFinishYear;
  final Map<int, Duration> totalTimeByFinishYear;

  @override
  List<Object> get props => <Object>[
        total,
        ratingSum,
        lowPriorityCount,
        nextUpCount,
        playingCount,
        playedCount,
        finishCount,
        totalTime,
        countByReleaseYear,
        countByRating,
        avgRatingByFinishYear,
        countByFinishYear,
        totalTimeByFinishYear,
      ];

  @override
  String toString() {
    return 'GameGeneralStatistics { '
        'Total: $total, '
        'Rating sum: $ratingSum, '
        'Low Priority count: $lowPriorityCount, '
        'Next Up count: $nextUpCount, '
        'Playing count: $playingCount, '
        'Played count: $playedCount, '
        'Finish count: $finishCount, '
        'Total Time: $totalTime, '
        'Count By Release Year: $countByReleaseYear, '
        'Count By Rating: $countByRating, '
        'Average Rating By Finish Year: $avgRatingByFinishYear, '
        'Count By Finish Year: $countByFinishYear, '
        'Total Time By Finish Year: $totalTimeByFinishYear'
        ' }';
  }
}

class GameYearStatistics extends _GameStatistics {
  const GameYearStatistics({
    required int total,
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
    required this.totalTimeByMonth,
  }) : super(
          total: total,
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
          totalTime: timeLogSum,
        );

  final Map<int, int> countByReleaseYear;
  final Map<int, int> countByRating;
  final Map<int, Duration> totalTimeByMonth;

  @override
  List<Object> get props => <Object>[
        total,
        ratingSum,
        lowPriorityCount,
        nextUpCount,
        playingCount,
        playedCount,
        finishCount,
        totalTime,
        countByReleaseYear,
        countByRating,
        totalTimeByMonth,
      ];

  @override
  String toString() {
    return 'GameGeneralStatistics { '
        'Total: $total, '
        'Rating sum: $ratingSum, '
        'Low Priority count: $lowPriorityCount, '
        'Next Up count: $nextUpCount, '
        'Playing count: $playingCount, '
        'Played count: $playedCount, '
        'Finish count: $finishCount, '
        'Total Time: $totalTime, '
        'Count By Release Year: $countByReleaseYear, '
        'Count By Rating: $countByRating, '
        'Total Time By Month: $totalTimeByMonth'
        ' }';
  }
}
