import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/bar_item.dart';
import 'package:game_collection/model/app_tab.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/tab/tab.dart';

import 'common/loading_icon.dart';
import 'common/show_snackbar.dart';
import 'bar_items.dart';
import 'item_list.dart';
import 'bloc_provider_route.dart';


class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TabBloc, AppTab> (
      builder: (BuildContext context, AppTab state) {
        BarItem barItem = barItems.elementAt(AppTab.values.indexOf(state));

        ItemListBloc selectedItemListBloc;
        switch(state) {
          case AppTab.game:
            selectedItemListBloc = BlocProvider.of<GameListBloc>(context);
            break;
          case AppTab.dlc:
            selectedItemListBloc = BlocProvider.of<DLCListBloc>(context);
            break;
          case AppTab.purchase:
            selectedItemListBloc = BlocProvider.of<PurchaseListBloc>(context);
            break;
          case AppTab.store:
            selectedItemListBloc = BlocProvider.of<StoreListBloc>(context);
            break;
          case AppTab.platform:
            selectedItemListBloc = BlocProvider.of<PlatformListBloc>(context);
            break;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(barItem.title + 's'),
            backgroundColor: barItem.color,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search in View',
                onPressed: () {
                  //TODO
                },
              ),
              IconButton(
                icon: Icon(Icons.sort_by_alpha),
                tooltip: 'Change Order',
                onPressed: () {
                  //TODO: Use enum or remove from constructor
                  selectedItemListBloc.add(UpdateSortOrder(null));
                },
              ),
              _HomepageAction(
                activeTab: state,
                onSelected: (String selectedView) {
                  selectedItemListBloc.add(UpdateView(selectedView));
                },
              ),
            ],
          ),
          body: _HomepageBody(
            itemListBloc: selectedItemListBloc,
            onDismiss: (CollectionItem item) {
              selectedItemListBloc.itemBloc.add(DeleteItem(item));
            },
          ),
          bottomNavigationBar: _HomepageTab(
            activeTab: state,
            onTap: (tab) {
              BlocProvider.of<TabBloc>(context).add(UpdateTab(tab));
            },
          ),
          floatingActionButton: _HomepageFAB(
            activeTab: state,
            onTap: () {
              selectedItemListBloc.itemBloc.add(AddItem());
            },
          ),
        );
      },
    );

  }

}

class _HomepageAction extends StatelessWidget {

  const _HomepageAction({Key key, this.activeTab, this.onSelected}) : super(key: key);

  final AppTab activeTab;
  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    BarItem barItem = barItems.elementAt(AppTab.values.indexOf(activeTab));

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

  final AppTab activeTab;
  final Function(AppTab) onTap;

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      type: BottomNavigationBarType.shifting,
      onTap: (index) {
        onTap(AppTab.values.elementAt(index));
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

  final AppTab activeTab;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    BarItem barItem = barItems.elementAt(AppTab.values.indexOf(activeTab));

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

  const _HomepageBody({Key key, @required this.itemListBloc, @required this.onDismiss}) : super(key: key);

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
            snackBarAction: SnackBarAction(
              label: "Open",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ItemDetailBuilder(state.item);
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
          );
        }
        if(state is ItemNotDeleted) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to delete",
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