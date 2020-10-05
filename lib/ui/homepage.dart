import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/app_tab.dart';
import 'package:game_collection/model/bar_data.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/tab/tab.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'list/list.dart';
import 'theme/theme.dart';


class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    AllListManagerBloc _allListManagerBloc = AllListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

    OwnedListManagerBloc _ownedListManagerBloc = OwnedListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

    RomListManagerBloc _romListManagerBloc = RomListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

    DLCListManagerBloc _dlcListManagerBloc = DLCListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

    PurchaseListManagerBloc _purchaseListManagerBloc = PurchaseListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

    StoreListManagerBloc _storeListManagerBloc = StoreListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

    PlatformListManagerBloc _platformListManagerBloc = PlatformListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<TabBloc>(
          create: (BuildContext context) {
            return TabBloc();
          },
        ),

        BlocProvider<AllListBloc>(
          create: (BuildContext context) {
            return AllListBloc(
              iCollectionRepository: CollectionRepository(),
              managerBloc: _allListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<OwnedListBloc>(
          create: (BuildContext context) {
            return OwnedListBloc(
              iCollectionRepository: CollectionRepository(),
              managerBloc: _ownedListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<RomListBloc>(
          create: (BuildContext context) {
            return RomListBloc(
              iCollectionRepository: CollectionRepository(),
              managerBloc: _romListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<DLCListBloc>(
          create: (BuildContext context) {
            return DLCListBloc(
              iCollectionRepository: CollectionRepository(),
              managerBloc: _dlcListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PurchaseListBloc>(
          create: (BuildContext context) {
            return PurchaseListBloc(
              iCollectionRepository: CollectionRepository(),
              managerBloc: _purchaseListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<StoreListBloc>(
          create: (BuildContext context) {
            return StoreListBloc(
              iCollectionRepository: CollectionRepository(),
              managerBloc: _storeListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PlatformListBloc>(
          create: (BuildContext context) {
            return PlatformListBloc(
              iCollectionRepository: CollectionRepository(),
              managerBloc: _platformListManagerBloc,
            )..add(LoadItemList());
          },
        ),

        BlocProvider<AllListManagerBloc>(
          create: (BuildContext context) {
            return _allListManagerBloc;
          },
        ),
        BlocProvider<OwnedListManagerBloc>(
          create: (BuildContext context) {
            return _ownedListManagerBloc;
          },
        ),
        BlocProvider<RomListManagerBloc>(
          create: (BuildContext context) {
            return _romListManagerBloc;
          },
        ),
        BlocProvider<DLCListManagerBloc>(
          create: (BuildContext context) {
            return _dlcListManagerBloc;
          },
        ),
        BlocProvider<PurchaseListManagerBloc>(
          create: (BuildContext context) {
            return _purchaseListManagerBloc;
          },
        ),
        BlocProvider<StoreListManagerBloc>(
          create: (BuildContext context) {
            return _storeListManagerBloc;
          },
        ),
        BlocProvider<PlatformListManagerBloc>(
          create: (BuildContext context) {
            return _platformListManagerBloc;
          },
        ),
      ],
      child: _HomepageBar(),
    );

  }

}

const List<BarData> barDatas = const[
  gameBarData,
  dlcBarData,
  purchaseBarData,
  storeBarData,
  platformBarData,
];

class _HomepageBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TabBloc, TabState> (
      builder: (BuildContext context, TabState state) {

        return Scaffold(
          appBar: _HomepageAppBar(
            state: state,
          ),
          body: _HomepageBody(
            state: state,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            currentIndex: state.mainTab.index,
            onTap: (index) {
              MainTab newMainTab = MainTab.values.elementAt(index);

              BlocProvider.of<TabBloc>(context).add(UpdateMainTab(newMainTab));
            },
            items: barDatas.map<BottomNavigationBarItem>( (barItem) {
              return BottomNavigationBarItem(
                label: barItem.title + 's',
                icon: Icon(barItem.icon),
                backgroundColor: barItem.color,
              );
            }).toList(growable: false),
          ),
          floatingActionButton: _HomepageFAB(
            state: state,
          ),
        );

      },
    );

  }
}

class _HomepageAppBar extends StatelessWidget with PreferredSizeWidget {
  _HomepageAppBar({Key key, @required this.state}) : super(key: key);

  final TabState state;

  @override
  final Size preferredSize = Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {

    switch(state.mainTab) {
      case MainTab.game:
        return GameAppBar(
          gameTab: state.gameTab,
        );
      case MainTab.dlc:
        return DLCAppBar();
      case MainTab.purchase:
        return PurchaseAppBar();
      case MainTab.store:
        return StoreAppBar();
      case MainTab.platform:
        return PlatformAppBar();
    }

    return Container();

  }

}

class _HomepageFAB extends StatelessWidget {
  const _HomepageFAB({Key key, @required this.state}) : super(key: key);

  final TabState state;

  @override
  Widget build(BuildContext context) {

    switch(state.mainTab) {
      case MainTab.game:
        return GameFAB(
          gameTab: state.gameTab,
        );
      case MainTab.dlc:
        return DLCFAB();
      case MainTab.purchase:
        return PurchaseFAB();
      case MainTab.store:
        return StoreFAB();
      case MainTab.platform:
        return PlatformFAB();
    }

    return Container();

  }

}

class _HomepageBody extends StatelessWidget {
  _HomepageBody({Key key, @required this.state}) : super(key: key);

  final TabState state;

  @override
  Widget build(BuildContext context) {

    switch(state.mainTab) {
      case MainTab.game:
        return GameTabs(
          gameTab: state.gameTab,
        );
      case MainTab.dlc:
        return DLCList();
      case MainTab.purchase:
        return PurchaseList();
      case MainTab.store:
        return StoreList();
      case MainTab.platform:
        return PlatformList();
    }

    return Container();

  }
}