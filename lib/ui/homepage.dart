import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/bar_item.dart';
import 'package:game_collection/model/app_tab.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/tab/tab.dart';
import 'package:game_collection/ui/bloc_provider_route.dart';

import 'package:game_collection/ui/common/loading_icon.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';

import 'bar_items.dart';
import 'item_list.dart';


class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TabBloc, AppTab> (
      builder: (BuildContext context, AppTab state) {
        BarItem barItem = barItems.elementAt(AppTab.values.indexOf(state));

        ItemListBloc selectedItemListBloc;
        ItemDetailBloc itemDetailBloc;
        switch(state) {
          case AppTab.game:
            selectedItemListBloc = BlocProvider.of<GameListBloc>(context);
            itemDetailBloc = BlocProvider.of<GameDetailBloc>(context);
            break;
          case AppTab.dlc:
            selectedItemListBloc = BlocProvider.of<DLCListBloc>(context);
            itemDetailBloc = BlocProvider.of<DLCDetailBloc>(context);
            break;
          case AppTab.purchase:
            selectedItemListBloc = BlocProvider.of<PurchaseListBloc>(context);
            //itemDetailBloc = BlocProvider.of<PurchaseDetailBloc>(context);
            break;
          case AppTab.store:
            selectedItemListBloc = BlocProvider.of<StoreListBloc>(context);
            //itemDetailBloc = BlocProvider.of<StoreDetailBloc>(context);
            break;
          case AppTab.platform:
            selectedItemListBloc = BlocProvider.of<PlatformListBloc>(context);
            //itemDetailBloc = BlocProvider.of<PlatformDetailBloc>(context);
            break;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(barItem.title + 's'),
            backgroundColor: barItem.color,
          ),
          body: _HomepageBody(
            activeTab: state,
            itemListBloc: selectedItemListBloc,
            itemDetailBloc: itemDetailBloc,
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
              selectedItemListBloc.itemBloc.add(AddItem(null));
            },
          ),
        );
      },
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

  const _HomepageBody({Key key, @required this.activeTab, @required this.itemListBloc, @required this.itemDetailBloc}) : super(key: key);

  final AppTab activeTab;
  final ItemListBloc itemListBloc;
  final ItemDetailBloc itemDetailBloc;

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
              itemDetailBloc: itemDetailBloc,
              activeTab: activeTab,
            );
          }
          //else EntityListLoading
          return LoadingIcon();

        },
      ),
    );

  }

}