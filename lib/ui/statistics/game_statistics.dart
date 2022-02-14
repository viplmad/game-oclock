import 'package:flutter/material.dart';

import 'package:backend/model/model.dart'
    show GameGeneralStatistics, GameYearStatistics;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;
import 'package:backend/utils/statistics_utils.dart';

import 'package:backend/bloc/item_statistics/item_statistics.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'statistics.dart';

class GameStatisticsView extends ItemStatisticsView<GameGeneralStatistics,
    GameYearStatistics, GameStatisticsBloc> {
  const GameStatisticsView({
    Key? key,
    required int viewIndex,
    required int? viewYear,
    required String viewTitle,
  }) : super(
          key: key,
          viewIndex: viewIndex,
          viewYear: viewYear,
          viewTitle: viewTitle,
        );

  @override
  GameStatisticsBloc statisticsBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return GameStatisticsBloc(
      viewIndex: viewIndex,
      viewYear: viewYear,
      collectionRepository: collectionRepository,
    );
  }

  @override
  _GameStatisticsBody statisticsBodyBuilder() {
    return _GameStatisticsBody(
      viewIndex: viewIndex,
      viewTitle: viewTitle,
    );
  }
}

class _GameStatisticsBody extends ItemStatisticsBody<GameGeneralStatistics,
    GameYearStatistics, GameStatisticsBloc> {
  const _GameStatisticsBody({
    Key? key,
    required int viewIndex,
    required String viewTitle,
  }) : super(key: key, viewIndex: viewIndex, viewTitle: viewTitle);

  static const int releaseYearIntervalChunk = 5;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).gamesString;

  @override
  String fromYearTitle(BuildContext context, int year) =>
      GameCollectionLocalisations.of(context).gamesFromYearString(year);

  @override
  List<Widget> statisticsGeneralFieldsBuilder(
    BuildContext context,
    GameGeneralStatistics stats,
  ) {
    final int totalItems = stats.total;

    final int playingCount = stats.playingCount;
    final int playedCount = stats.playedCount;
    final int playingPlayedCount = playingCount + playedCount;
    final Duration totalTime = stats.totalTime;

    return <Widget>[
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalGamesString,
        value: totalItems,
      ),
      statisticsDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalTimeString,
        value: totalTime,
      ),
      statisticsDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgTimeString,
        value: (playingPlayedCount > 0)
            ? Duration(minutes: totalTime.inMinutes ~/ playingPlayedCount)
            : Duration.zero,
      ),
      statisticsDoubleField(
        fieldName: GameCollectionLocalisations.of(context).avgRatingString,
        value: (playingPlayedCount > 0) ? stats.ratingSum / playedCount : 0,
      ),
      statisticsGroupField(
        groupName: GameCollectionLocalisations.of(context).countByStatusString,
        fields: <StatisticsField>[
          statisticsIntField(
            context,
            fieldName:
                GameCollectionLocalisations.of(context).lowPriorityString,
            value: stats.lowPriorityCount,
            total: totalItems,
          ),
          statisticsIntField(
            context,
            fieldName: GameCollectionLocalisations.of(context).nextUpString,
            value: stats.nextUpCount,
            total: totalItems,
          ),
          statisticsIntField(
            context,
            fieldName: GameCollectionLocalisations.of(context).playingString,
            value: playingCount,
            total: totalItems,
          ),
          statisticsIntField(
            context,
            fieldName: GameCollectionLocalisations.of(context).playedString,
            value: playedCount,
            total: totalItems,
          ),
        ],
      ),
      const Divider(),
      _countByRating(context, stats.countByRating),
      const Divider(),
      _countByReleaseYearInIntervals(
        context,
        stats.minReleaseYear,
        stats.maxReleaseYear,
        stats.countByReleaseYear,
      ),
      const Divider(),
      _avgRatingByFinishDate(context, stats.avgRatingByFinishYear),
      const Divider(),
      _sumTimeByFinishDate(context, stats.totalTimeByFinishYear),
      const Divider(),
      _countByFinishDate(context, stats.countByFinishYear),
    ];
  }

  @override
  List<Widget> statisticsYearFieldsBuilder(
    BuildContext context,
    GameYearStatistics stats,
  ) {
    final int totalItems = stats.total;

    final int playingCount = stats.playingCount;
    final int playedCount = stats.playedCount;
    final int playingPlayedCount = playingCount + playedCount;
    final Duration totalTime = stats.totalTime;

    return <Widget>[
      statisticsIntField(
        context,
        fieldName:
            GameCollectionLocalisations.of(context).totalGamesPlayedString,
        value: totalItems,
      ),
      statisticsDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalTimeString,
        value: totalTime,
      ),
      statisticsDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgTimeString,
        value: (playingPlayedCount > 0)
            ? Duration(minutes: totalTime.inMinutes ~/ playingPlayedCount)
            : Duration.zero,
      ),
      statisticsDoubleField(
        fieldName: GameCollectionLocalisations.of(context).avgRatingString,
        value: (playingPlayedCount > 0) ? stats.ratingSum / playedCount : 0,
      ),
      const Divider(),
      _countByRating(context, stats.countByRating),
      const Divider(),
      _countByReleaseYearInIntervals(
        context,
        stats.minReleaseYear,
        stats.maxReleaseYear,
        stats.countByReleaseYear,
      ),
      const Divider(),
      _sumTimeByMonth(context, stats.totalTimeByMonth),
    ];
  }

  //#region Common
  Widget _countByReleaseYearInIntervals(
    BuildContext context,
    int minReleaseYear,
    int maxReleaseYear,
    Map<int, int> data,
  ) {
    final List<int> intervals = StatisticsUtils.createIntervals(
      releaseYearIntervalChunk,
      minReleaseYear,
      maxReleaseYear,
    );
    final List<String> domainLabels = formatIntervalLabels<int>(
      intervals,
      (int element) =>
          GameCollectionLocalisations.of(context).formatShortYear(element),
    );

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName:
          GameCollectionLocalisations.of(context).countByReleaseYearString,
      domainLabels: domainLabels,
      values: StatisticsUtils.intervalCount(intervals, data),
      labelAccessor: (int value) => '$value',
    );
  }

  Widget _countByRating(BuildContext context, Map<int, int> data) {
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      data.keys,
      (int element) => element.toString(),
    );

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName:
          GameCollectionLocalisations.of(context).countByRatingString,
      domainLabels: domainLabels,
      values: data.values.toList(growable: false),
      labelAccessor: (int value) => '$value',
    );
  }
  //#endregion Common

  //#region General
  Widget _avgRatingByFinishDate(BuildContext context, Map<int, double> data) {
    final Iterable<int> finishYears = data.keys;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      finishYears,
      (int element) =>
          GameCollectionLocalisations.of(context).formatYear(element),
    );

    return finishYears.isNotEmpty
        ? statisticsHistogram<double>(
            height: MediaQuery.of(context).size.height / 2,
            histogramName: GameCollectionLocalisations.of(context)
                .avgRatingByFinishDateString,
            domainLabels: domainLabels,
            values: data.values.toList(growable: false),
            labelAccessor: (double value) => value.toStringAsFixed(2),
          )
        : Container();
  }

  Widget _sumTimeByFinishDate(BuildContext context, Map<int, Duration> data) {
    final Iterable<int> finishYears = data.keys;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      finishYears,
      (int element) =>
          GameCollectionLocalisations.of(context).formatYear(element),
    );

    return finishYears.isNotEmpty
        ? statisticsHistogram<int>(
            height: MediaQuery.of(context).size.height / 2,
            histogramName: GameCollectionLocalisations.of(context)
                .sumTimeByFinishDateString,
            domainLabels: domainLabels,
            values: data.values
                .map((Duration time) => time.inHours)
                .toList(growable: false),
            labelAccessor: (int value) =>
                GameCollectionLocalisations.of(context).formatHours(value),
          )
        : Container();
  }

  Widget _countByFinishDate(BuildContext context, Map<int, int> data) {
    final Iterable<int> finishYears = data.keys;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      finishYears,
      (int element) =>
          GameCollectionLocalisations.of(context).formatYear(element),
    );

    return finishYears.isNotEmpty
        ? statisticsHistogram<int>(
            height: MediaQuery.of(context).size.height / 2,
            histogramName:
                GameCollectionLocalisations.of(context).countByFinishDate,
            domainLabels: domainLabels,
            values: data.values.toList(growable: false),
            labelAccessor: (int value) => '$value',
          )
        : Container();
  }
  //#endregion General

  //#region Year
  Widget _sumTimeByMonth(BuildContext context, Map<int, Duration> data) {
    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumTimeByMonth,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.values
          .map((Duration time) => time.inHours)
          .toList(growable: false),
      labelAccessor: (int value) =>
          GameCollectionLocalisations.of(context).formatHours(value),
    );
  }
  //#endregion Year
}
