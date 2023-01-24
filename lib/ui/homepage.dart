import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:logic/model/model.dart' show MainTab;
import 'package:logic/service/service.dart' show GameCollectionService;
import 'package:logic/bloc/tab/tab.dart';
import 'package:logic/bloc/item_list/item_list.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';
import 'package:logic/bloc/about/about.dart';
import 'package:logic/bloc/start_game_view/start_game_view.dart';

import 'package:game_collection/localisations/localisations.dart';

import 'utils/shape_utils.dart';
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
    final GameCollectionService collectionService =
        RepositoryProvider.of<GameCollectionService>(context);

    final GameListManagerBloc gameListManagerBloc = GameListManagerBloc(
      collectionService: collectionService,
    );

    final DLCListManagerBloc dlcListManagerBloc = DLCListManagerBloc(
      collectionService: collectionService,
    );

    final PlatformListManagerBloc platformListManagerBloc =
        PlatformListManagerBloc(
      collectionService: collectionService,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<TabBloc>(
          create: (BuildContext context) {
            return TabBloc();
          },
        ),
        BlocProvider<GameListBloc>(
          create: (BuildContext context) {
            return GameListBloc(
              collectionService: collectionService,
              managerBloc: gameListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<DLCListBloc>(
          create: (BuildContext context) {
            return DLCListBloc(
              collectionService: collectionService,
              managerBloc: dlcListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<PlatformListBloc>(
          create: (BuildContext context) {
            return PlatformListBloc(
              collectionService: collectionService,
              managerBloc: platformListManagerBloc,
            )..add(LoadItemList());
          },
        ),
        BlocProvider<GameListManagerBloc>(
          create: (BuildContext context) {
            return gameListManagerBloc;
          },
        ),
        BlocProvider<DLCListManagerBloc>(
          create: (BuildContext context) {
            return dlcListManagerBloc;
          },
        ),
        BlocProvider<PlatformListManagerBloc>(
          create: (BuildContext context) {
            return platformListManagerBloc;
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
      PlatformTheme.barData(context),
    ];

    return BlocBuilder<TabBloc, MainTab>(
      builder: (BuildContext context, MainTab state) {
        return Scaffold(
          appBar: _HomepageAppBar(
            tab: state,
          ),
          drawer: const _HomepageDrawer(),
          body: _HomepageBody(
            tab: state,
          ),
          bottomNavigationBar: nav_bar_background.NavigationBar(
            selectedIndex: state.index,
            onDestinationSelected: (int destinationSelectedIndex) {
              final MainTab selectedMainTab =
                  MainTab.values.elementAt(destinationSelectedIndex);

              BlocProvider.of<TabBloc>(context).add(UpdateTab(selectedMainTab));
            },
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: barDatum
                .map<nav_bar_background.NavigationDestination>(
                    (BarData barItem) {
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
            tab: state,
          ),
        );
      },
    );
  }
}

class _HomepageAppBar extends StatelessWidget with PreferredSizeWidget {
  const _HomepageAppBar({
    Key? key,
    required this.tab,
  }) : super(key: key);

  final MainTab tab;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case MainTab.game:
        return const GameAppBar();
      case MainTab.dlc:
        return const DLCAppBar();
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
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              GameCollectionLocalisations.appTitle,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title:
                Text(GameCollectionLocalisations.of(context).gameListsString),
            onTap: () async {
              Navigator.pushNamed(
                context,
                tagListRoute,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              GameCollectionLocalisations.of(context).changeRepositoryString,
            ),
            onTap: () async {
              Navigator.pushNamed(
                context,
                serverSettingsRoute,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_carousel),
            title: Text(
              GameCollectionLocalisations.of(context).changeStartGameViewString,
            ),
            onTap: () async {
              showDialog<void>(
                context: context,
                builder: _changeStartGameViewDialog,
              );
            },
          ),
          const Divider(),
          BlocBuilder<AboutBloc, AboutState>(
            bloc: AboutBloc()..add(LoadAbout()),
            builder: (BuildContext context, AboutState state) {
              String version = '';
              if (state is AboutLoaded) {
                version = _createVersionString(state.packageInfo);
              }

              return ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  '${GameCollectionLocalisations.of(context).aboutString} - $version',
                ),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: GameCollectionLocalisations.appTitle,
                    applicationVersion: version,
                    applicationIcon: Container(
                      margin: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: ShapeUtils.fabBorderRadius,
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

  Widget _changeStartGameViewDialog(BuildContext context) {
    final List<String> gameViews = GameTheme.views(context);

    return BlocProvider<StartGameViewBloc>(
      create: (BuildContext context) {
        return StartGameViewBloc()..add(LoadStartGameView());
      },
      child: AlertDialog(
        title: Text(
          GameCollectionLocalisations.of(context).startGameViewString,
        ),
        content: BlocBuilder<StartGameViewBloc, int?>(
          builder: (BuildContext context, int? startViewIndex) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: gameViews.map((String view) {
                final int viewIndex = gameViews.indexOf(view);

                return RadioListTile<int>(
                  title: Text(view),
                  groupValue: startViewIndex,
                  value: viewIndex,
                  onChanged: (_) async {
                    BlocProvider.of<StartGameViewBloc>(context).add(
                      UpdateStartGameView(
                        viewIndex,
                      ),
                    );

                    Navigator.maybePop<void>(context);
                  },
                );
              }).toList(growable: false),
            );
          },
        ),
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
    required this.tab,
  }) : super(key: key);

  final MainTab tab;

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case MainTab.game:
        return const GameFAB();
      case MainTab.dlc:
        return const DLCFAB();
      case MainTab.platform:
        return const PlatformFAB();
    }
  }
}

class _HomepageBody extends StatelessWidget {
  const _HomepageBody({
    Key? key,
    required this.tab,
  }) : super(key: key);

  final MainTab tab;

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case MainTab.game:
        return const GameList();
      case MainTab.dlc:
        return const DLCList();
      case MainTab.platform:
        return const PlatformList();
    }
  }
}
