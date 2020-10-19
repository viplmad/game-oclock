import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_statistics/item_statistics.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'statistics.dart';


class GameStatisticsArguments extends StatisticsArguments<Game> {
  const GameStatisticsArguments({
    @required List<Game> items,
    @required String viewTitle,
    @required this.tabTitle,
  }) : super(items: items, viewTitle: viewTitle);

  final String tabTitle;
}

class GameStatistics extends ItemStatistics<Game, GamesData, GameStatisticsBloc> {
  const GameStatistics({
    Key key,
    @required List<Game> items,
    @required String viewTitle,
    @required this.tabTitle,
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
    Key key,
    @required String viewTitle,
    @required this.tabTitle,
  }) : super(key: key, viewTitle: viewTitle);

  final String tabTitle;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).gamesString + ' ($tabTitle)';

  @override
  String fromYearTitle(BuildContext context, int year) => GameCollectionLocalisations.of(context).gamesFromYearString(year);

  @override
  List<Widget> statisticsGeneralFieldsBuilder(BuildContext context, GamesData data) {
    int totalItems = data.length;

    int playingCount = data.playingCount();
    int playedCount = data.playedCount();
    int playingPlayedCount = playingCount + playedCount;
    int minutesSum = data.minutesSum();

    return [
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
        fields: [
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
      Divider(),
      _countByReleaseYear(context, data),
      Divider(),
      _avgRatingByFinishDate(context, data),
      Divider(),
      _sumMinutesByFinishDate(context, data),
      Divider(),
      _countByFinishDate(context, data),
    ];

  }

  @override
  List<Widget> statisticsYearFieldsBuilder(BuildContext context, GamesData data) {
    int totalItems = data.length;

    int playingCount = data.playingCount();
    int playedCount = data.playedCount();
    int playingPlayedCount = playingCount + playedCount;
    int minutesSum = data.minutesSum();

    return [
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
      Divider(),
      _countByRating(context, data),
      Divider(),
      _countByReleaseYear(context, data),
      Divider(),
      _countByTime(context, data),
      Divider(),
      _sumMinutesByMonth(context, data),
    ];

  }

  //#region Common
  Widget _countByReleaseYear(BuildContext context, GamesData data) {

    List<int> intervals = [1975, 1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, 2020];
    List<String> labels = formatIntervalLabels(intervals);

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByReleaseYearString,
      labels: labels,
      values: data.intervalReleaseYearCount(intervals),
    );

  }

  Widget _countByRating(BuildContext context, GamesData data) {

    List<int> intervals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    List<String> labels = formatIntervalLabelsEqual(intervals);

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByRatingString,
      labels: labels,
      values: data.intervalRatingCount(intervals),
    );

  }

  Widget _countByTime(BuildContext context, GamesData data) {

    List<int> intervals = [0, 5, 10, 15, 20, 25, 50, 100];
    List<String> labels = formatIntervalLabelsWithInitialAndLast(intervals);

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByTimeString,
      labels: labels,
      values: data.intervalTimeCount(intervals),
    );

  }
  //#endregion Common

  //#region General
  Widget _avgRatingByFinishDate(BuildContext context, GamesData data) {

    List<int> finishYears = data.finishYears;
    List<String> labels = formatIntervalLabelsEqual(finishYears);

    return finishYears.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).avgRatingByFinishDateString,
        labels: labels,
        values: data.yearlyRatingAverage(finishYears),
      ) : Container();

  }

  Widget _sumMinutesByFinishDate(BuildContext context, GamesData data) {

    List<int> finishYears = data.finishYears;
    List<String> labels = formatIntervalLabelsEqual(finishYears);

    return finishYears.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumMinutesByFinishDateString,
        labels: labels,
        values: data.yearlyHoursSum(finishYears),
      ) : Container();

  }

  Widget _countByFinishDate(BuildContext context, GamesData data) {

    List<int> finishYears = data.finishYears;
    List<String> labels = formatIntervalLabelsEqual(finishYears);

    return finishYears.isNotEmpty?
      statisticsHistogram<int>(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).countByFinishDate,
        labels: labels,
        values: data.yearlyFinishDateCount(finishYears),
      ) : Container();

  }
  //#endregion General

  //#region Year
  Widget _sumMinutesByMonth(BuildContext context, GamesData data) {

    return statisticsHistogram<int>(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumMinutesByMonth,
      labels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlyHoursSum().values,
    );

  }
  //#endregion Year
}