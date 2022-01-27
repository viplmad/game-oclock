import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_statistics/item_statistics.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'statistics.dart';


class GameStatisticsArguments extends StatisticsArguments<Game> {
  const GameStatisticsArguments({
    required List<Game> items,
    required String viewTitle,
    required this.tabTitle,
  }) : super(items: items, viewTitle: viewTitle);

  final String tabTitle;
}

class GameStatistics extends ItemStatistics<Game, GamesData, GameStatisticsBloc> {
  const GameStatistics({
    Key? key,
    required List<Game> items,
    required String viewTitle,
    required this.tabTitle,
  }) : super(key: key, items: items, viewTitle: viewTitle);

  final String tabTitle;

  @override
  GameStatisticsBloc statisticsBlocBuilder() {

    return GameStatisticsBloc(
      items: items,
    );

  }

  @override
  _GameStatisticsBody statisticsBodyBuilder() {

    return _GameStatisticsBody(
      viewTitle: viewTitle,
      tabTitle: tabTitle,
    );

  }
}

class _GameStatisticsBody extends ItemStatisticsBody<Game, GamesData, GameStatisticsBloc> {
  const _GameStatisticsBody({
    Key? key,
    required String viewTitle,
    required this.tabTitle,
  }) : super(key: key, viewTitle: viewTitle);

  final String tabTitle;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).gamesString + ' ($tabTitle)';

  @override
  String fromYearTitle(BuildContext context, int year) => GameCollectionLocalisations.of(context).gamesFromYearString(year);

  @override
  List<Widget> statisticsGeneralFieldsBuilder(BuildContext context, GamesData data) {
    final int totalItems = data.length;

    final int playingCount = data.playingCount();
    final int playedCount = data.playedCount();
    final int playingPlayedCount = playingCount + playedCount;
    final int minutesSum = data.minutesSum();

    return <Widget>[
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalGamesString,
        value: totalItems,
      ),
      statisticsDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumTimeString,
        value: Duration(minutes: minutesSum),
      ),
      statisticsDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgTimeString,
        value: Duration(minutes: (playingPlayedCount > 0)? minutesSum ~/ playingPlayedCount : 0),
      ),
      statisticsDoubleField(
        fieldName: GameCollectionLocalisations.of(context).avgRatingString,
        value: (playingPlayedCount > 0)? data.ratingSum() / playingPlayedCount : 0,
      ),
      statisticsGroupField(
        groupName: GameCollectionLocalisations.of(context).countByStatusString,
        fields: <StatisticsField>[
          statisticsIntField(
            context,
            fieldName: GameCollectionLocalisations.of(context).lowPriorityString,
            value: data.lowPriorityCount(),
            total: totalItems,
          ),
          statisticsIntField(
            context,
            fieldName: GameCollectionLocalisations.of(context).nextUpString,
            value: data.nextUpCount(),
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
      _countByReleaseYear(context, data),
      const Divider(),
      _avgRatingByFinishDate(context, data),
      const Divider(),
      _sumTimeByFinishDate(context, data),
      const Divider(),
      _countByFinishDate(context, data),
    ];

  }

  @override
  List<Widget> statisticsYearFieldsBuilder(BuildContext context, GamesData data) {
    final int totalItems = data.length;

    final int playingCount = data.playingCount();
    final int playedCount = data.playedCount();
    final int playingPlayedCount = playingCount + playedCount;
    final int minutesSum = data.minutesSum();

    return <Widget>[
      statisticsIntField(
        context,
        fieldName: GameCollectionLocalisations.of(context).totalGamesPlayedString,
        value: totalItems,
      ),
      statisticsDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).sumTimeString,
        value: Duration(minutes: minutesSum),
      ),
      statisticsDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).avgTimeString,
        value: Duration(minutes: (playingPlayedCount > 0)? minutesSum ~/ playingPlayedCount : 0),
      ),
      statisticsDoubleField(
        fieldName: GameCollectionLocalisations.of(context).avgRatingString,
        value: (playingPlayedCount > 0)? data.ratingSum() / playingPlayedCount : 0,
      ),
      const Divider(),
      _countByRating(context, data),
      const Divider(),
      _countByReleaseYear(context, data),
      const Divider(),
      _countByTime(context, data),
      const Divider(),
      _sumTimeByMonth(context, data),
    ];

  }

  //#region Common
  Widget _countByReleaseYear(BuildContext context, GamesData data) {

    final List<int> intervals = <int>[1975, 1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, 2020];
    final List<String> domainLabels = formatIntervalLabels<int>(
      intervals,
      (int element) => GameCollectionLocalisations.of(context).formatShortYear(element),
    );

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByReleaseYearString,
      domainLabels: domainLabels,
      values: data.intervalReleaseYearCount(intervals),
      labelAccessor: (int value) => '$value',
    );

  }

  Widget _countByRating(BuildContext context, GamesData data) {

    final List<int> intervals = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      intervals,
      (int element) => element.toString(),
    );

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByRatingString,
      domainLabels: domainLabels,
      values: data.intervalRatingCount(intervals),
      labelAccessor: (int value) => '$value',
    );

  }

  Widget _countByTime(BuildContext context, GamesData data) {

    final List<int> intervals = <int>[0, 5, 10, 15, 20, 25, 30, 40, 50, 100];
    final List<String> domainLabels = formatIntervalLabelsWithInitialAndLast<int>(
      intervals,
      (int element) => element.toString(),
    );

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByTimeString,
      domainLabels: domainLabels,
      values: data.intervalTimeCount(intervals),
      vertical: false,
      labelAccessor: (int value) => '$value',
    );

  }
  //#endregion Common

  //#region General
  Widget _avgRatingByFinishDate(BuildContext context, GamesData data) {

    final List<int> finishYears = data.finishYears;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      finishYears,
      (int element) => GameCollectionLocalisations.of(context).formatYear(element),
    );

    return finishYears.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).avgRatingByFinishDateString,
        domainLabels: domainLabels,
        values: data.yearlyRatingAverage(finishYears),
        labelAccessor: (int value) => '$value',
      ) : Container();

  }

  Widget _sumTimeByFinishDate(BuildContext context, GamesData data) {

    final List<int> finishYears = data.finishYears;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      finishYears,
      (int element) => GameCollectionLocalisations.of(context).formatYear(element),
    );

    return finishYears.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumTimeByFinishDateString,
        domainLabels: domainLabels,
        values: data.yearlyHoursSum(finishYears),
        labelAccessor: (int value) => GameCollectionLocalisations.of(context).formatHours(value),
      ) : Container();

  }

  Widget _countByFinishDate(BuildContext context, GamesData data) {

    final List<int> finishYears = data.finishYears;
    final List<String> domainLabels = formatIntervalLabelsEqual<int>(
      finishYears,
      (int element) => GameCollectionLocalisations.of(context).formatYear(element),
    );

    return finishYears.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).countByFinishDate,
        domainLabels: domainLabels,
        values: data.yearlyFinishDateCount(finishYears),
        labelAccessor: (int value) => '$value',
      ) : Container();

  }
  //#endregion General

  //#region Year
  Widget _sumTimeByMonth(BuildContext context, GamesData data) {

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumTimeByMonth,
      domainLabels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyHoursSum().values,
      labelAccessor: (int value) => GameCollectionLocalisations.of(context).formatHours(value),
    );

  }
  //#endregion Year
}