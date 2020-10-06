import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';
import 'package:game_collection/model/app_tab.dart';

import 'package:game_collection/bloc/tab/tab.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
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
class _OwnedAppBar extends _GameAppBar<OwnedListBloc> {}
class _RomAppBar extends _GameAppBar<RomListBloc> {}

abstract class _GameAppBar<K extends ItemListBloc<Game>> extends ItemAppBar<Game, K> {

  @override
  BarData barData = gameBarData;

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

class _AllFAB extends _GameFAB<AllListManagerBloc> {}
class _OwnedFAB extends _GameFAB<OwnedListManagerBloc> {}
class _RomFAB extends _GameFAB<RomListManagerBloc> {}

abstract class _GameFAB<S extends ItemListManagerBloc<Game>> extends ItemFAB<Game, S> {

  @override
  BarData barData = gameBarData;

}


const List<BarData> tabItems = [
  allTabData,
  gameTabData,
  romTabData,
];

class GameTabs extends StatelessWidget {
  const GameTabs({Key key, this.gameTab}) : super(key: key);

  final GameTab gameTab;

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: tabItems.length,
      initialIndex: gameTab.index,
      child: Builder(
        builder: (BuildContext context) {
          DefaultTabController.of(context).addListener( () {
            GameTab newGameTab = GameTab.values.elementAt(DefaultTabController.of(context).index);

            BlocProvider.of<TabBloc>(context).add(UpdateGameTab(newGameTab));
          });

          return NestedScrollView(
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
          );
        },
      ),
    );

  }

}

class _AllGameList extends _GameList<AllListBloc, AllListManagerBloc> {}
class _OwnedGameList extends _GameList<OwnedListBloc, OwnedListManagerBloc> {}
class _RomGameList extends _GameList<RomListBloc, RomListManagerBloc> {}

abstract class _GameList<K extends ItemListBloc<Game>, S extends ItemListManagerBloc<Game>> extends ItemList<Game, K, S> {

  @override
  String detailRouteName = gameDetailRoute;

  @override
  _GameListBody<K> itemListBodyBuilder({@required List<Game> items, @required int viewIndex, @required void Function(Game) onDelete, @required ListStyle style}) {

    return _GameListBody<K>(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
    );

  }

}

class _GameListBody<K extends ItemListBloc<Game>> extends ItemListBody<Game, K> {

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
  String detailRouteName = gameDetailRoute;

  @override
  String localSearchRouteName = gameLocalSearchRoute;

  @override
  String statisticsRouteName = gameStatisticsRoute;

  @override
  String getViewTitle() {

    return gameBarData.views.elementAt(viewIndex);

  }

}