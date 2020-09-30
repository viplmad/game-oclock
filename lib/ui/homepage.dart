import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/bar_item.dart';
import 'package:game_collection/model/app_tab.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/maintab/maintab.dart';

import 'common/loading_icon.dart';
import 'common/show_snackbar.dart';
import 'bar_items.dart';
import 'tab_items.dart';
import 'item_list.dart';
import 'bloc_provider_route.dart';


GameTab activeGameTab = GameTab.all;
class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MainTabBloc, MainTab> (
      builder: (BuildContext context, MainTab state) {

        switch(state) {
          case MainTab.game:
            switch(activeGameTab) {
              case GameTab.all:
                return _HomepageIntermediate<Game>(
                  activeTab: state,
                  itemListBloc: BlocProvider.of<AllListBloc>(context),
                );
              case GameTab.game:
                return _HomepageIntermediate<Game>(
                  activeTab: state,
                  itemListBloc: BlocProvider.of<GameListBloc>(context),
                );
              case GameTab.rom:
                return _HomepageIntermediate<Game>(
                  activeTab: state,
                  itemListBloc: BlocProvider.of<RomListBloc>(context),
                );
            }
            break;
          case MainTab.dlc:
            return _HomepageIntermediate<DLC>(
              activeTab: state,
              itemListBloc: BlocProvider.of<DLCListBloc>(context),
            );
          case MainTab.purchase:
            return _HomepageIntermediate<Purchase>(
              activeTab: state,
              itemListBloc: BlocProvider.of<PurchaseListBloc>(context),
            );
          case MainTab.store:
            return _HomepageIntermediate<Store>(
              activeTab: state,
              itemListBloc: BlocProvider.of<StoreListBloc>(context),
            );
          case MainTab.platform:
            return _HomepageIntermediate<Platform>(
              activeTab: state,
              itemListBloc: BlocProvider.of<PlatformListBloc>(context),
            );
        }

        return Container();
      },
    );

  }

}

class _HomepageIntermediate<T extends CollectionItem> extends StatelessWidget {
  const _HomepageIntermediate({Key key, this.activeTab, this.itemListBloc}) : super(key: key);

  final MainTab activeTab;
  final ItemListBloc<T> itemListBloc;

  @override
  Widget build(BuildContext context) {
    BarItem barItem = barItems.elementAt(MainTab.values.indexOf(activeTab));

    return Scaffold(
      appBar: AppBar(
        title: Text(barItem.title + 's'),
        backgroundColor: barItem.color,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort_by_alpha),
            tooltip: 'Change Order',
            onPressed: () {
              itemListBloc.add(UpdateSortOrder());
            },
          ),
          IconButton(
            icon: Icon(Icons.grid_on),
            tooltip: 'Change to Grid/List',
            onPressed: () {
              itemListBloc.add(UpdateIsGrid());
            },
          ),
          _HomepageViewAction(
            barItem: barItem,
            onSelected: (String selectedView) {
              itemListBloc.add(UpdateView(selectedView));
            },
          ),
        ],
      ),
      body: _HomepageBody<T>(
        itemListBloc: itemListBloc,
        onDismiss: (CollectionItem item) {
          itemListBloc.itemBloc.add(DeleteItem<T>(item));
        },
      ),
      bottomNavigationBar: _HomepageTab(
        activeTab: activeTab,
        onTap: (tab) {
          BlocProvider.of<MainTabBloc>(context).add(UpdateMainTab(tab));
        },
      ),
      floatingActionButton: _HomepageFAB(
        barItem: barItem,
        onTap: () {
          itemListBloc.itemBloc.add(AddItem());
        },
      ),
    );

  }
}

class _HomepageViewAction extends StatelessWidget {

  const _HomepageViewAction({Key key, this.barItem, this.onSelected}) : super(key: key);

  final BarItem barItem;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {

    return PopupMenuButton(
      icon: Icon(Icons.view_carousel),
      tooltip: "Change View",
      itemBuilder: (BuildContext context) {
        return barItem.views.map( (String view) {
          return PopupMenuItem(
            child: ListTile(
              title: Text(view),
            ),
            value: view,
          );
        }).toList();
      },
      onSelected: onSelected,
    );

  }

}

class _HomepageTab extends StatelessWidget {

  _HomepageTab({Key key, @required this.activeTab, @required this.onTap}) : super(key: key);

  final MainTab activeTab;
  final Function(MainTab) onTap;

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      currentIndex: MainTab.values.indexOf(activeTab),
      type: BottomNavigationBarType.shifting,
      onTap: (index) {
        onTap(MainTab.values.elementAt(index));
      },
      items: barItems.map<BottomNavigationBarItem>( (barItem) {
        return BottomNavigationBarItem(
          title: Text(barItem.title + 's'),
          icon: Icon(barItem.icon),
          backgroundColor: barItem.color,
        );
      }).toList(growable: false),
    );

  }

}

class _HomepageFAB extends StatelessWidget {

  _HomepageFAB({Key key, @required this.barItem, @required this.onTap}) : super(key: key);

  final BarItem barItem;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      onPressed: () {
        onTap();
      },
      tooltip: 'New ' + barItem.title,
      child: Icon(Icons.add),
      backgroundColor: barItem.color,
    );

  }
}

class _HomepageBody<T extends CollectionItem> extends StatelessWidget {

  const _HomepageBody({Key key, @required this.itemListBloc, @required this.onDismiss}) : super(key: key);

  final ItemListBloc<T> itemListBloc;
  final void Function(CollectionItem) onDismiss;

  ItemBloc<T> get itemBloc => itemListBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    return BlocListener<ItemBloc<T>, ItemState>(
      bloc: itemBloc,
      listener: (BuildContext context, ItemState state) {
        if(state is ItemAdded<T>) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Added",
            seconds: 2,
            snackBarAction: SnackBarAction(
              label: "Open",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ItemDetailProvider<T>(state.item);
                    },
                  ),
                );
              },
            ),
          );
        }
        if(state is ItemNotAdded) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to add",
            seconds: 2,
            snackBarAction: dialogSnackBarAction(
                context,
                label: "More",
                title: "Unable to add",
                content: state.error,
            ),
          );
        }
        if(state is ItemDeleted<T>) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Deleted",
            seconds: 2,
          );
        }
        if(state is ItemNotDeleted) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to delete",
            seconds: 2,
            snackBarAction: dialogSnackBarAction(
                context,
                label: "More",
                title: "Unable to delete",
                content: state.error,
            ),
          );
        }
      },
      child: BlocBuilder<ItemListBloc<T>, ItemListState>(
        bloc: itemListBloc,
        builder: (BuildContext context, ItemListState state) {

          if(state is ItemListLoaded<T>) {

            if(T is Game) {
              return GameTabBar();
            }

            return ItemList<T>(
              items: state.items,
              activeView: state.view,
              onDismiss: onDismiss,
              isGridView: state.isGrid,
            );

          }
          if(state is ItemListNotLoaded) {

            return Center(
              child: Text(state.error),
            );

          }

          return LoadingIcon();

        },
      ),
    );

  }

}

class GameTabBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: tabItems.length,
      child: Builder(
        builder: (BuildContext context) {
          DefaultTabController.of(context).addListener( () {
            activeGameTab = GameTab.values.elementAt(DefaultTabController.of(context).index);
          });

          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverPersistentHeader(
                  pinned: false,
                  floating: true,
                  delegate: _TabsDelegate(
                    tabBar: TabBar(
                      tabs: tabItems.map<Tab>( (barItem) {
                        return Tab(
                          text: barItem.title,
                        );
                      }).toList(growable: false),
                    ),
                    color: Colors.redAccent,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                ItemListBlocBuilder<Game>(
                  itemListBloc: BlocProvider.of<AllListBloc>(context),
                ),
                ItemListBlocBuilder<Game>(
                  itemListBloc: BlocProvider.of<GameListBloc>(context),
                ),
                ItemListBlocBuilder<Game>(
                  itemListBloc: BlocProvider.of<RomListBloc>(context),
                ),
              ],
            ),
          );

        },
      ),
    );

  }

}

class ItemListBlocBuilder<T extends CollectionItem> extends StatelessWidget {

  ItemListBlocBuilder({@required this.itemListBloc});

  final ItemListBloc<T> itemListBloc;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ItemListBloc<T>, ItemListState>(
      bloc: itemListBloc,
      builder: (BuildContext context, ItemListState state) {

        if(state is ItemListLoaded<T>) {

          return ItemList<T>(
            items: state.items,
            activeView: state.view,
            onDismiss: (CollectionItem item) {
              itemListBloc.itemBloc.add(DeleteItem<T>(item));
            },
            isGridView: state.isGrid,
          );

        }
        if(state is ItemListNotLoaded) {

          return Center(
            child: Text(state.error),
          );

        }

        return LoadingIcon();

      },
    );

  }

}

class _TabsDelegate extends SliverPersistentHeaderDelegate {
  _TabsDelegate({@required this.tabBar, this.color}) : super();

  final TabBar tabBar;
  final Color color;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: color?? Theme.of(context).primaryColor,
      child: tabBar,
    );

  }

  @override
  bool shouldRebuild(_TabsDelegate oldDelegate) {
    return false;
  }
}