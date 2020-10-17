import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_statistics/item_statistics.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'statistics.dart';


class GameStatisticsArguments extends StatisticsArguments<Game> {
  GameStatisticsArguments({
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
  ItemStatisticsBody<Game, GamesData, GameStatisticsBloc> statisticsBodyBuilder() {

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
  List<Widget> statisticsGeneralFieldsBuilder(BuildContext context, GamesData data) {
    int totalItems = data.length;

    int playingCount = data.playingCount();
    int playedCount = data.playedCount();
    int playingPlayedCount = playingCount + playedCount;
    int minutesSum = data.minutesSum();

    List<int> finishYears = data.finishYears();

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
      //TODO avg rating by year
      statisticsDoubleField(
        fieldName: GameCollectionLocalisations.of(context).avgRatingString,
        value: (playingPlayedCount > 0)? data.totalRating() / playingPlayedCount : 0,
      ),
      Divider(),
      _sumMinutesByFinishDate(context, data, finishYears),
      Divider(),
      _countByFinishDate(context, data, finishYears),
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

  //#region General
  Widget _countByReleaseYear(BuildContext context, GamesData data) {
    
    List<int> intervals = [1975, 1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, 2020];

    return statisticsHistogram(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByReleaseYearString,
      labels: intervals.map<String>((int e) => e.toString()).toList(growable: false),
      values: data.intervalReleaseYears(intervals),
    );
    
  }

  Widget _sumMinutesByFinishDate(BuildContext context, GamesData data, List<int> finishYears) {

    return finishYears.isNotEmpty?
      statisticsHistogram(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).sumMinutesByFinishDateString,
        labels: finishYears.map<String>((int e) => e.toString()).toList(growable: false),
        values: data.yearlySumHours(finishYears),
      ) : Container();

  }

  Widget _countByFinishDate(BuildContext context, GamesData data, List<int> finishYears) {

    return finishYears.isNotEmpty?
      statisticsHistogram(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: GameCollectionLocalisations.of(context).countByFinishDate,
        labels: finishYears.map<String>((int e) => e.toString()).toList(growable: false),
        values: data.yearlyCountFinishDate(finishYears),
      ) : Container();

  }
  //#endregion General

  //#region Year
  Widget _countByRating(BuildContext context, GamesData data) {

    List<int> intervals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    return statisticsHistogram(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByRatingString,
      labels: intervals.map<String>((int e) => e.toString()).toList(growable: false),
      values: data.intervalRating(intervals),
    );

  }

  Widget _countByTime(BuildContext context, GamesData data) {

    List<int> intervals = [0, 5, 10, 15, 20, 25, 50, 100];

    return statisticsHistogram(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).countByTimeString,
      labels: intervals.map<String>((int e) => e.toString()).toList(growable: false),
      values: data.intervalTime(intervals),
    );

  }

  Widget _sumMinutesByMonth(BuildContext context, GamesData data) {

    return statisticsHistogram(
      height: MediaQuery.of(context).size.height / 2,
      histogramName: GameCollectionLocalisations.of(context).sumMinutesByMonth,
      labels: GameCollectionLocalisations.of(context).shortMonths,
      values: data.monthlySumHours().values,
    );

  }
  //#endregion Year

}