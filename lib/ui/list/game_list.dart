import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/app_tab.dart';

import 'package:game_collection/bloc/tab/tab.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import '../common/tabs_delegate.dart';
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
class _OwnedAppBar extends _GameAppBar<OwnedListBloc> {}
class _RomAppBar extends _GameAppBar<RomListBloc> {}

abstract class _GameAppBar<K extends ItemListBloc<Game>> extends ItemAppBar<Game, K> {

  @override
  final Color themeColor = GameTheme.primaryColour;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).gamesString;

  @override
  List<String> views(BuildContext context) => GameTheme.views(context);

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
  final Color themeColor = GameTheme.primaryColour;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameString;

}

class GameTabs extends StatelessWidget {
  const GameTabs({Key key, this.gameTab}) : super(key: key);

  final GameTab gameTab;

  @override
  Widget build(BuildContext context) {
    List<String> tabTitles = [
      GameCollectionLocalisations.of(context).allString,
      GameCollectionLocalisations.of(context).ownedString,
      GameCollectionLocalisations.of(context).romsString,
    ];

    return DefaultTabController(
      length: tabTitles.length,
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
                      tabs: tabTitles.map<Tab>( (String title) {
                        return Tab(
                          text: title,
                        );
                      }).toList(growable: false),
                    ),
                    color: GameTheme.accentColour,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _AllGameList(
                  tabTitle: tabTitles.elementAt(0),
                ),
                _OwnedGameList(
                  tabTitle: tabTitles.elementAt(1),
                ),
                _RomGameList(
                  tabTitle: tabTitles.elementAt(2),
                ),
              ],
            ),
          );
        },
      ),
    );

  }

}

class _AllGameList extends _GameList<AllListBloc, AllListManagerBloc> {
  _AllGameList({String tabTitle}) : super(tabTitle: tabTitle);
}
class _OwnedGameList extends _GameList<OwnedListBloc, OwnedListManagerBloc> {
  _OwnedGameList({String tabTitle}) : super(tabTitle: tabTitle);
}
class _RomGameList extends _GameList<RomListBloc, RomListManagerBloc> {
  _RomGameList({String tabTitle}) : super(tabTitle: tabTitle);
}

abstract class _GameList<K extends ItemListBloc<Game>, S extends ItemListManagerBloc<Game>> extends ItemList<Game, K, S> {
  _GameList({this.tabTitle});

  final String tabTitle;

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameString;

  @override
  _GameListBody<K> itemListBodyBuilder({@required List<Game> items, @required int viewIndex, @required void Function(Game) onDelete, @required ListStyle style}) {

    return _GameListBody<K>(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
      tabTitle: tabTitle,
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
    @required this.tabTitle,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    onDelete: onDelete,
    style: style,
  );

  final String tabTitle;

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  final String localSearchRouteName = gameLocalSearchRoute;

  @override
  final String statisticsRouteName = gameStatisticsRoute;

  void Function() onStatisticsTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        statisticsRouteName,
        arguments: GameStatisticsArguments(
          items: items,
          viewTitle: viewTitle(context),
          tabTitle: tabTitle,
        ),
      );
    };

  }

  @override
  String itemTitle(Game item) => GameTheme.itemTitle(item);

  @override
  Widget cardBuilder(BuildContext context, Game item) {

    return GameTheme.itemCard(context, item, onTap);

  }

  @override
  Widget gridBuilder(BuildContext context, Game item) {

    return GameTheme.itemGrid(context, item, onTap);

  }

  @override
  String viewTitle(BuildContext context) {

    return GameTheme.views(context).elementAt(viewIndex);

  }

}