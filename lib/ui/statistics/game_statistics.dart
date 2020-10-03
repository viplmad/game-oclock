import 'package:flutter/material.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'statistics.dart';


class GameStatistics extends ItemStatistics {

  GameStatistics({
    Key key,
    @required this.yearData,
  }) : super(
    key: key,
    itemName: gameTable,
  );

  GamesDataYear yearData;
  int get totalItems => yearData.length;

  @override
  List<Widget> statisticsFieldsBuilder(BuildContext context) {
    int lowPriorityGames = yearData.getLowPriorityGamesCount();
    int nextUpGames = yearData.getNextUpGamesCount();
    int playingGames = yearData.getPlayingGamesCount();
    int playedGames = yearData.getPlayedGamesCount();

    int totalMinutes = yearData.getTotalMinutes();
    int averageMinutes = (totalMinutes / playedGames).round();

    return [
      statisticsIntField(
        fieldName: "Total",
        value: totalItems,
      ),
      statisticsGroupField(
        groupName: "By Status",
        fields: [
          statisticsIntField(
            fieldName: statuses.elementAt(0),
            value: lowPriorityGames,
            total: totalItems,
          ),
          statisticsIntField(
            fieldName: statuses.elementAt(1),
            value: nextUpGames,
            total: totalItems,
          ),
          statisticsIntField(
            fieldName: statuses.elementAt(2),
            value: playingGames,
            total: totalItems,
          ),
          statisticsIntField(
            fieldName: statuses.elementAt(3),
            value: playedGames,
            total: totalItems,
          ),
        ],
      ),
      statisticsHistogram(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: "Rating",
        labels: ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).map<String>((int e) => e.toString()).toList(growable: false),
        values: yearData.getIntervalRating([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
      ),
      Divider(),
      statisticsHistogram(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: "Release Years",
        labels: ([1975, 1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, 2020]).map<String>((int e) => e.toString()).toList(growable: false),
        values: yearData.getIntervalReleaseYears([1975, 1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, 2020]),
      ),
      Divider(),
      statisticsHistogram(
        height: MediaQuery.of(context).size.height / 2,
        histogramName: "Hours Played",
        labels: ([0, 5, 10, 15, 20, 25, 50, 100]).map<String>((int e) => e.toString()).toList(growable: false),
        values: yearData.getIntervalTime([0, 5, 10, 15, 20, 25, 50, 100]),
      ),
      statisticsDurationField(
        fieldName: "Total Hours",
        value: Duration(minutes: totalMinutes),
      ),
      statisticsDurationField(
        fieldName: "Average Hours",
        value: Duration(minutes: averageMinutes),
      )
    ];

  }
}