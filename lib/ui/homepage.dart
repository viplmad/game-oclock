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


class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MainTabBloc, MainTab> (
      builder: (BuildContext context, MainTab state) {
        BarItem barItem = barItems.elementAt(MainTab.values.indexOf(state));

        return Scaffold(
          appBar: AppBar(
            title: Text(barItem.title + 's'),
            backgroundColor: barItem.color,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.sort_by_alpha),
                tooltip: 'Change Order',
                onPressed: () {
                  ItemListProvider(context, state).add(UpdateSortOrder());
                },
              ),
              _HomepageViewAction(
                activeTab: state,
                onSelected: (String selectedView) {
                  ItemListProvider(context, state).add(UpdateView(selectedView));
                },
              ),
            ],
          ),
          body: _HomepageBody(
            activeTab: state,
            itemListBloc: ItemListProvider(context, state),
            onDismiss: (CollectionItem item) {
              ItemListProvider(context, state).itemBloc.add(DeleteItem(item));
            },
          ),
          bottomNavigationBar: _HomepageTab(
            activeTab: state,
            onTap: (tab) {
              BlocProvider.of<MainTabBloc>(context).add(UpdateMainTab(tab));
            },
          ),
          floatingActionButton: _HomepageFAB(
            activeTab: state,
            onTap: () {
              ItemListProvider(context, state).itemBloc.add(AddItem());
            },
          ),
        );
      },
    );

  }

}

class _HomepageViewAction extends StatelessWidget {

  const _HomepageViewAction({Key key, this.activeTab, this.onSelected}) : super(key: key);

  final MainTab activeTab;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    BarItem barItem = barItems.elementAt(MainTab.values.indexOf(activeTab));

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

  _HomepageFAB({Key key, @required this.activeTab, @required this.onTap}) : super(key: key);

  final MainTab activeTab;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    BarItem barItem = barItems.elementAt(MainTab.values.indexOf(activeTab));

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

class _HomepageBody extends StatelessWidget {

  const _HomepageBody({Key key, @required this.activeTab, @required this.itemListBloc, @required this.onDismiss}) : super(key: key);

  final MainTab activeTab;
  final ItemListBloc itemListBloc;
  final Function(CollectionItem) onDismiss;

  ItemBloc get itemBloc => itemListBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    return BlocListener<ItemBloc, ItemState>(
      bloc: itemBloc,
      listener: (BuildContext context, ItemState state) {
        if(state is ItemAdded) {
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
                      return ItemDetailProvider(state.item);
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
        if(state is ItemDeleted) {
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
      child: BlocBuilder<ItemListBloc, ItemListState>(
        bloc: itemListBloc,
        builder: (BuildContext context, ItemListState state) {

          if(state is ItemListLoaded) {

            if(activeTab == MainTab.game) {
              return GameTabBar();
            }
            return ItemList(
              items: state.items,
              activeView: state.view,
              onDismiss: onDismiss,
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
                ItemListBlocBuilder(
                  itemListBloc: BlocProvider.of<AllListBloc>(context),
                ),
                ItemListBlocBuilder(
                  itemListBloc: BlocProvider.of<GameListBloc>(context),
                ),
                ItemListBlocBuilder(
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

class ItemListBlocBuilder extends StatelessWidget {

  ItemListBlocBuilder({@required this.itemListBloc});

  final ItemListBloc itemListBloc;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ItemListBloc, ItemListState>(
      bloc: itemListBloc,
      builder: (BuildContext context, ItemListState state) {

        if(state is ItemListLoaded) {

          return ItemList(
            items: state.items,
            activeView: state.view,
            onDismiss: (CollectionItem item) {
              itemListBloc.itemBloc.add(DeleteItem(item));
            },
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