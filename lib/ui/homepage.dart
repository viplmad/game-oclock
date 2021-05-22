import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/repository/repository.dart';

import 'package:backend/bloc/tab/tab.dart';
import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:backend/model/app_tab.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'route_constants.dart';
import 'list/list.dart';
import 'theme/theme.dart';
import 'common/bar_data.dart';

class Homepage extends StatelessWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final AllListManagerBloc _allListManagerBloc = AllListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final OwnedListManagerBloc _ownedListManagerBloc = OwnedListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final RomListManagerBloc _romListManagerBloc = RomListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final DLCListManagerBloc _dlcListManagerBloc = DLCListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final PurchaseListManagerBloc _purchaseListManagerBloc = PurchaseListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final StoreListManagerBloc _storeListManagerBloc = StoreListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    final PlatformListManagerBloc _platformListManagerBloc = PlatformListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<TabBloc>(
          create: (BuildContext context) {
            return TabBloc();
          },
        ),

        BlocProvider<AllListBloc>(
          create: (BuildContext context) {
            return AllListBloc(
              iCollectionRepository: ICollectionRepository.iCollectionRepository!,
              managerBloc: _allListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<OwnedListBloc>(
          create: (BuildContext context) {
            return OwnedListBloc(
              iCollectionRepository: ICollectionRepository.iCollectionRepository!,
              managerBloc: _ownedListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<RomListBloc>(
          create: (BuildContext context) {
            return RomListBloc(
              iCollectionRepository: ICollectionRepository.iCollectionRepository!,
              managerBloc: _romListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<DLCListBloc>(
          create: (BuildContext context) {
            return DLCListBloc(
              iCollectionRepository: ICollectionRepository.iCollectionRepository!,
              managerBloc: _dlcListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PurchaseListBloc>(
          create: (BuildContext context) {
            return PurchaseListBloc(
              iCollectionRepository: ICollectionRepository.iCollectionRepository!,
              managerBloc: _purchaseListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<StoreListBloc>(
          create: (BuildContext context) {
            return StoreListBloc(
              iCollectionRepository: ICollectionRepository.iCollectionRepository!,
              managerBloc: _storeListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PlatformListBloc>(
          create: (BuildContext context) {
            return PlatformListBloc(
              iCollectionRepository: ICollectionRepository.iCollectionRepository!,
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
      child: const _HomepageBar(),
    );

  }
}

class _HomepageBar extends StatelessWidget {
  const _HomepageBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<BarData> barDatum = <BarData>[
      GameTheme.barData(context),
      DLCTheme.barData(context),
      PurchaseTheme.barData(context),
      StoreTheme.barData(context),
      PlatformTheme.barData(context),
    ];

    return BlocBuilder<TabBloc, TabState> (
      builder: (BuildContext context, TabState state) {

        return Scaffold(
          appBar: _HomepageAppBar(
            state: state,
          ),
          drawer: const _HomepageDrawer(),
          body: _HomepageBody(
            state: state,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            currentIndex: state.mainTab.index,
            onTap: (int index) {
              final MainTab newMainTab = MainTab.values.elementAt(index);

              BlocProvider.of<TabBloc>(context).add(UpdateMainTab(newMainTab));
            },
            items: barDatum.map<BottomNavigationBarItem>( (BarData barItem) {
              return BottomNavigationBarItem(
                label: barItem.title,
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
  const _HomepageAppBar({
    Key? key,
    required this.state,
  }) : super(key: key);

  final TabState state;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {

    switch(state.mainTab) {
      case MainTab.game:
        return GameAppBar(
          gameTab: state.gameTab,
        );
      case MainTab.dlc:
        return const DLCAppBar();
      case MainTab.purchase:
        return const PurchaseAppBar();
      case MainTab.store:
        return const StoreAppBar();
      case MainTab.platform:
        return const PlatformAppBar();
    }

  }
}

class _HomepageDrawer extends StatelessWidget {
  const _HomepageDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              GameCollectionLocalisations.appTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(GameCollectionLocalisations.of(context).repositorySettingsString),
            onTap: () {
              Navigator.pushNamed(
                context,
                repositorySettingsRoute,
              );
            },
          ),
        ],
      ),
    );

  }
}

class _HomepageFAB extends StatelessWidget {
  const _HomepageFAB({
    Key? key,
    required this.state,
  }) : super(key: key);

  final TabState state;

  @override
  Widget build(BuildContext context) {

    switch(state.mainTab) {
      case MainTab.game:
        return GameFAB(
          gameTab: state.gameTab,
        );
      case MainTab.dlc:
        return const DLCFAB();
      case MainTab.purchase:
        return const PurchaseFAB();
      case MainTab.store:
        return const StoreFAB();
      case MainTab.platform:
        return const PlatformFAB();
    }

  }
}

class _HomepageBody extends StatelessWidget {
  const _HomepageBody({
    Key? key,
    required this.state,
  }) : super(key: key);

  final TabState state;

  @override
  Widget build(BuildContext context) {

    switch(state.mainTab) {
      case MainTab.game:
        return GameTabs(
          gameTab: state.gameTab,
        );
      case MainTab.dlc:
        return const DLCList();
      case MainTab.purchase:
        return const PurchaseList();
      case MainTab.store:
        return const StoreList();
      case MainTab.platform:
        return const PlatformList();
    }

  }
}