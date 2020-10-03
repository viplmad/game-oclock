import 'package:flutter/material.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import 'package:game_collection/model/app_tab.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';
import 'package:game_collection/model/model.dart';

import '../theme/theme.dart';
import '../detail/detail.dart';
import '../statistics/statistics.dart';

import 'list.dart';


class GameAppBar extends StatelessWidget {
  const GameAppBar({Key key, @required this.gameTab}) : super(key: key);

  final GameTab gameTab;

  @override
  Widget build(BuildContext context) {

    switch(gameTab) {
      case GameTab.all:
        return _AllAppBar();
      case GameTab.game:
        return _OwnedAppBar();
      case GameTab.rom:
        return _RomAppBar();
    }

    return Container();

  }

}

class _AllAppBar extends _GameAppBar<AllListBloc> {}
class _OwnedAppBar extends _GameAppBar<GameListBloc> {}
class _RomAppBar extends _GameAppBar<RomListBloc> {}

abstract class _GameAppBar<K extends ItemListBloc<Game>> extends ItemAppBar<Game, K> {

  @override
  BarData getBarData() {

    return gameBarData;

  }

}


class GameFAB extends StatelessWidget {
  const GameFAB({Key key, @required this.gameTab}) : super(key: key);

  final GameTab gameTab;

  @override
  Widget build(BuildContext context) {

    switch(gameTab) {
      case GameTab.all:
        return _AllFAB();
      case GameTab.game:
        return _OwnedFAB();
      case GameTab.rom:
        return _RomFAB();
    }

    return Container();

  }

}

class _AllFAB extends _GameFAB<AllListBloc> {}
class _OwnedFAB extends _GameFAB<GameListBloc> {}
class _RomFAB extends _GameFAB<RomListBloc> {}

abstract class _GameFAB<K extends ItemListBloc<Game>> extends ItemFAB<Game, K> {

  @override
  BarData getBarData() {

    return gameBarData;

  }

}


const List<BarData> tabItems = [
  allTabData,
  gameTabData,
  romTabData,
];

class GameTabs extends StatelessWidget {
  const GameTabs({Key key, this.gameTab}) : super(key: key);

  final GameTab gameTab; //TODO use for smth

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: tabItems.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: TabsDelegate(
                tabBar: TabBar(
                  tabs: tabItems.map<Tab>( (tabItem) {
                    return Tab(
                      text: tabItem.title,
                    );
                  }).toList(growable: false),
                ),
                color: gameAccentColour,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            _AllGameList(),
            _OwnedGameList(),
            _RomGameList(),
          ],
        ),
      ),
    );

  }

}

class _AllGameList extends _GameList<AllListBloc> {}
class _OwnedGameList extends _GameList<GameListBloc> {}
class _RomGameList extends _GameList<RomListBloc> {}

abstract class _GameList<K extends ItemListBloc<Game>> extends ItemList<Game, K> {

  @override
  ItemDetail<Game, GameDetailBloc> detailBuilder(Game game) {

    return GameDetail(
      item: game,
    );

  }

  @override
  _GameListBody itemListBodyBuilder({@required List<Game> items, @required int viewIndex, @required void Function(Game) onDelete, @required ListStyle style}) {

    return _GameListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
    );

  }

}

class _GameListBody extends ItemListBody<Game> {

  _GameListBody({
    Key key,
    @required List<Game> items,
    @required int viewIndex,
    @required void Function(Game) onDelete,
    @required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    onDelete: onDelete,
    style: style,
  );

  @override
  String getViewTitle() {

    return gameBarData.views.elementAt(viewIndex);

  }

  @override
  ItemDetail<Game, GameDetailBloc> detailBuilder(Game game) {

    return GameDetail(
      item: game,
    );

  }

  @override
  Widget statisticsBuilder() {

    return GameStatistics(
      yearData: GamesData(
        games: items,
      ).getYearData(2020),
    );

  }

}