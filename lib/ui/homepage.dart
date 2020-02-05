import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/bar_item.dart';
import 'package:game_collection/model/app_tab.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/tab/tab.dart';

import 'package:game_collection/ui/common/loading_icon.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';

import 'bar_items.dart';
import 'item_list.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<GameListBloc>(
          create: (BuildContext context) {
            return GameListBloc(
              itemBloc: BlocProvider.of<GameBloc>(context),
            )..add(LoadItemList());
          },
        ),
        BlocProvider<DLCListBloc>(
          create: (BuildContext context) {
            return DLCListBloc(
              itemBloc: BlocProvider.of<DLCBloc>(context),
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PlatformListBloc>(
          create: (BuildContext context) {
            return PlatformListBloc(
              itemBloc: BlocProvider.of<PlatformBloc>(context),
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PurchaseListBloc>(
          create: (BuildContext context) {
            return PurchaseListBloc(
              itemBloc: BlocProvider.of<PurchaseBloc>(context),
            )..add(LoadItemList());
          },
        ),
        BlocProvider<StoreListBloc>(
          create: (BuildContext context) {
            return StoreListBloc(
              itemBloc: BlocProvider.of<StoreBloc>(context),
            )..add(LoadItemList());
          },
        ),
      ],
      child: TabHomepage(),
    );

  }

}

class TabHomepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TabBloc, AppTab> (
      builder: (BuildContext context, AppTab state) {
        BarItem barItem = barItems.elementAt(AppTab.values.indexOf(state));

        ItemBloc selectedItemBloc;
        ItemListBloc selectedItemListBloc;
        switch(state) {
          case AppTab.game:
            selectedItemBloc = BlocProvider.of<GameBloc>(context);
            selectedItemListBloc = BlocProvider.of<GameListBloc>(context);
            break;
          case AppTab.dlc:
            selectedItemBloc = BlocProvider.of<DLCBloc>(context);
            selectedItemListBloc = BlocProvider.of<DLCListBloc>(context);
            break;
          case AppTab.purchase:
            selectedItemBloc = BlocProvider.of<PurchaseBloc>(context);
            selectedItemListBloc = BlocProvider.of<PurchaseListBloc>(context);
            break;
          case AppTab.store:
            selectedItemBloc = BlocProvider.of<StoreBloc>(context);
            selectedItemListBloc = BlocProvider.of<StoreListBloc>(context);
            break;
          case AppTab.platform:
            selectedItemBloc = BlocProvider.of<PlatformBloc>(context);
            selectedItemListBloc = BlocProvider.of<PlatformListBloc>(context);
            break;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(barItem.title + 's'),
            backgroundColor: barItem.color,
          ),
          body: BodySelector(
            activeTab: state,
            itemBloc: selectedItemBloc,
            itemListBloc: selectedItemListBloc,
          ),
          bottomNavigationBar: TabSelector(
            activeTab: state,
            onTap: (tab) {
              BlocProvider.of<TabBloc>(context).add(UpdateTab(tab));
            },
          ),
          floatingActionButton: FABSelector(
            activeTab: state,
            onTap: () {
              selectedItemBloc.add(AddItem(null));
            },
          ),
        );
      },
    );

  }

}

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTap;

  TabSelector({Key key, @required this.activeTab, @required this.onTap}) : super(key: key);

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

class FABSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function() onTap;

  FABSelector({Key key, @required this.activeTab, @required this.onTap}) : super(key: key);

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

class BodySelector extends StatelessWidget {

  final AppTab activeTab;
  final ItemBloc itemBloc;
  final ItemListBloc itemListBloc;

  const BodySelector({Key key, @required this.activeTab, @required this.itemBloc, @required this.itemListBloc}) : super(key: key);

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
              itemBloc: itemBloc,
            );
          }
          //else EntityListLoading
          return LoadingIcon();

        },
      ),
    );

  }

}