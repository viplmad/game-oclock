import 'dart:async';

import 'package:backend/model/model.dart';

import 'item_statistics.dart';


class GameStatisticsBloc extends ItemStatisticsBloc<Game, GamesData> {
  GameStatisticsBloc({
    required List<Game> items,
  }) : super(items: items);

  @override
  Future<GamesData> getGeneralItemData() {

    return Future<GamesData>.value(GamesData(items));

  }

  @override
  Future<GamesData> getItemData(LoadYearItemStatistics event) {

    final List<Game> yearItems = items.where((Game item) => item.finishDate?.year == event.year).toList(growable: false);
    return Future<GamesData>.value(GamesData(yearItems));

  }
}