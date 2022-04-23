import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/tab/tab.dart';
import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';
import 'package:backend/bloc/about/about.dart';

import 'package:backend/model/app_tab.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'list/list.dart';
import 'theme/theme.dart';
import 'common/bar_data.dart';
import 'common/navigation_destination_background.dart' as nav_bar_background;
import 'route_constants.dart';

class Homepage extends StatelessWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameCollectionRepository _collectionRepository =
        RepositoryProvider.of<GameCollectionRepository>(context);

    final AllListManagerBloc _allListManagerBloc = AllListManagerBloc(
      collectionRepository: _collectionRepository,
    );

    final OwnedListManagerBloc _ownedListManagerBloc = OwnedListManagerBloc(
      collectionRepository: _collectionRepository,
    );

    final RomListManagerBloc _romListManagerBloc = RomListManagerBloc(
      collectionRepository: _collectionRepository,
    );

    final DLCListManagerBloc _dlcListManagerBloc = DLCListManagerBloc(
      collectionRepository: _collectionRepository,
    );

    final PurchaseListManagerBloc _purchaseListManagerBloc =
        PurchaseListManagerBloc(
      collectionRepository: _collectionRepository,
    );

    final StoreListManagerBloc _storeListManagerBloc = StoreListManagerBloc(
      collectionRepository: _collectionRepository,
    );

    final PlatformListManagerBloc _platformListManagerBloc =
        PlatformListManagerBloc(
      collectionRepository: _collectionRepository,
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
              collectionRepository: _collectionRepository,
              managerBloc: _allListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<OwnedListBloc>(
          create: (BuildContext context) {
            return OwnedListBloc(
              collectionRepository: _collectionRepository,
              managerBloc: _ownedListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<RomListBloc>(
          create: (BuildContext context) {
            return RomListBloc(
              collectionRepository: _collectionRepository,
              managerBloc: _romListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<DLCListBloc>(
          create: (BuildContext context) {
            return DLCListBloc(
              collectionRepository: _collectionRepository,
              managerBloc: _dlcListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PurchaseListBloc>(
          create: (BuildContext context) {
            return PurchaseListBloc(
              collectionRepository: _collectionRepository,
              managerBloc: _purchaseListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<StoreListBloc>(
          create: (BuildContext context) {
            return StoreListBloc(
              collectionRepository: _collectionRepository,
              managerBloc: _storeListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PlatformListBloc>(
          create: (BuildContext context) {
            return PlatformListBloc(
              collectionRepository: _collectionRepository,
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

    return BlocBuilder<TabBloc, TabState>(
      builder: (BuildContext context, TabState state) {
        return Scaffold(
          appBar: _HomepageAppBar(
            state: state,
          ),
          drawer: const _HomepageDrawer(),
          body: _HomepageBody(
            state: state,
          ),
          bottomNavigationBar: nav_bar_background.NavigationBar(
            selectedIndex: state.mainTab.index,
            onDestinationSelected: (int destinationSelectedIndex) {
              final MainTab selectedMainTab = MainTab.values.elementAt(destinationSelectedIndex);

              BlocProvider.of<TabBloc>(context).add(UpdateMainTab(selectedMainTab));
            },
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: barDatum.map<nav_bar_background.NavigationDestination>((BarData barItem) {
              return nav_bar_background.NavigationDestination(
                label: barItem.title,
                icon: Icon(
                  barItem.icon,
                ),
                indicatorColor: barItem.color,
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
    switch (state.mainTab) {
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
            child: const Text(
              GameCollectionLocalisations.appTitle,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title:
                Text(GameCollectionLocalisations.of(context).gameListsString),
            onTap: () {
              Navigator.pushNamed(
                context,
                gameTagListRoute,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              GameCollectionLocalisations.of(context).repositorySettingsString,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                repositorySettingsRoute,
              );
            },
          ),
          const Divider(),
          BlocBuilder<AboutBloc, AboutState>(
            bloc: AboutBloc(),
            builder: (BuildContext context, AboutState state) {
              String version = '';
              if (state is AboutLoaded) {
                version = _createVersionString(state.packageInfo);
              }

              return ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  GameCollectionLocalisations.of(context).aboutString,
                ),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: GameCollectionLocalisations.appTitle,
                    applicationVersion: version,
                    applicationIcon: Container(
                      margin: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                        child: Image.asset(
                          'assets/images/icon.png',
                          height: 48.0,
                          width: 48.0,
                        ),
                      ),
                    ),
                    applicationLegalese: GameCollectionLocalisations.of(context)
                        .licenseInfoString,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  static String _createVersionString(PackageInfo packageInfo) {
    return 'v${packageInfo.version}+${packageInfo.buildNumber}';
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
    switch (state.mainTab) {
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
    switch (state.mainTab) {
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
