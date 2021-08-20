import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';
import 'package:game_collection/ui/list/game_tag_list.dart';

import 'route_constants.dart';
import 'connect.dart';
import 'homepage.dart';
import 'settings/settings.dart';
import 'detail/detail.dart';
import 'search/search.dart';
import 'statistics/statistics.dart';
import 'calendar/calendar.dart';
import 'theme/theme.dart';

export 'route_constants.dart';


Route<dynamic> onGenerateRoute(RouteSettings settings) {

  switch(settings.name) {
    case connectRoute:
      return _pageRoute(
        const Connectpage(),
      );

    case homeRoute:
      return _pageRoute(
        const Homepage(),
      );

    case repositorySettingsRoute:
      return _pageRoute(
        const RepositorySettings(),
      );

    case gameDetailRoute:
      final DetailArguments<Game> detailArguments = settings.arguments as DetailArguments<Game>;
      return _pageRoute(
        GameDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case dlcDetailRoute:
      final DetailArguments<DLC> detailArguments = settings.arguments as DetailArguments<DLC>;
      return _pageRoute(
        DLCDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: DLCTheme.themeData,
      );

    case purchaseDetailRoute:
      final DetailArguments<Purchase> detailArguments = settings.arguments as DetailArguments<Purchase>;
      return _pageRoute(
        PurchaseDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: PurchaseTheme.themeData,
      );

    case storeDetailRoute:
      final DetailArguments<Store> detailArguments = settings.arguments as DetailArguments<Store>;
      return _pageRoute(
        StoreDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: StoreTheme.themeData,
      );

    case platformDetailRoute:
      final DetailArguments<Platform> detailArguments = settings.arguments as DetailArguments<Platform>;
      return _pageRoute(
        PlatformDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: PlatformTheme.themeData,
      );

    case gameTagDetailRoute:
      final DetailArguments<GameTag> detailArguments = settings.arguments as DetailArguments<GameTag>;
      return _pageRoute(
        GameTagDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: GameTagTheme.themeData,
      );

    case gameTagListRoute:
      return _pageRoute(
        const GameTagList(),
        themeDataBuilder: GameTagTheme.themeData,
      );

    case gameStatisticsRoute:
      final GameStatisticsArguments statisticsArguments = settings.arguments as GameStatisticsArguments;
      return _pageRoute(
        GameStatistics(
          items: statisticsArguments.items,
          viewTitle: statisticsArguments.viewTitle,
          tabTitle: statisticsArguments.tabTitle,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case purchaseStatisticsRoute:
      final StatisticsArguments<Purchase> statisticsArguments = settings.arguments as StatisticsArguments<Purchase>;
      return _pageRoute(
        PurchaseStatistics(
          items: statisticsArguments.items,
          viewTitle: statisticsArguments.viewTitle,
        ),
        themeDataBuilder: PurchaseTheme.themeData,
      );

    case gameSingleCalendarRoute:
      final SingleGameCalendarArguments gameCalendarArguments = settings.arguments as SingleGameCalendarArguments;
      return _pageRoute(
        SingleGameCalendar(
          itemId: gameCalendarArguments.itemId,
          onUpdate: gameCalendarArguments.onUpdate,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case gameMultiCalendarRoute:
      return _pageRoute(
        const MultiGameCalendar(),
        themeDataBuilder: GameTheme.themeData,
      );

    case gameSearchRoute:
      return _pageRoute<Game>(
        const GameSearch(),
        themeDataBuilder: GameTheme.themeData,
      );

    case dlcSearchRoute:
      return _pageRoute<DLC>(
        const DLCSearch(),
        themeDataBuilder: DLCTheme.themeData,
      );

    case purchaseSearchRoute:
      return _pageRoute<Purchase>(
        const PurchaseSearch(),
        themeDataBuilder: PurchaseTheme.themeData,
      );

    case storeSearchRoute:
      return _pageRoute<Store>(
        const StoreSearch(),
        themeDataBuilder: StoreTheme.themeData,
      );

    case platformSearchRoute:
      return _pageRoute<Platform>(
        const PlatformSearch(),
        themeDataBuilder: PlatformTheme.themeData,
      );

    case systemSearchRoute:
      return _pageRoute<System>(
        const SystemSearch(),
      );

    case gameTagSearchRoute:
      return _pageRoute<GameTag>(
        const GameTagSearch(),
      );

    case purchaseTypeSearchRoute:
      return _pageRoute<PurchaseType>(
        const PurchaseTypeSearch(),
      );

    case gameLocalSearchRoute:
      return _pageRoute(
        GameLocalSearch(
          items: settings.arguments as List<Game>,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case dlcLocalSearchRoute:
      return _pageRoute(
        DLCLocalSearch(
          items: settings.arguments as List<DLC>,
        ),
        themeDataBuilder: DLCTheme.themeData,
      );

    case purchaseLocalSearchRoute:
      return _pageRoute(
        PurchaseLocalSearch(
          items: settings.arguments as List<Purchase>,
        ),
        themeDataBuilder: PurchaseTheme.themeData,
      );

    case storeLocalSearchRoute:
      return _pageRoute(
        StoreLocalSearch(
          items: settings.arguments as List<Store>,
        ),
        themeDataBuilder: StoreTheme.themeData,
      );

    case platformLocalSearchRoute:
      return _pageRoute(
        PlatformLocalSearch(
          items: settings.arguments as List<Platform>,
        ),
        themeDataBuilder: PlatformTheme.themeData,
      );

    case systemLocalSearchRoute:
      return _pageRoute(
        SystemLocalSearch(
          items: settings.arguments as List<System>,
        ),
      );

    case gameTagLocalSearchRoute:
      return _pageRoute(
        GameTagLocalSearch(
          items: settings.arguments as List<GameTag>,
        ),
      );

    case purchaseTypeLocalSearchRoute:
      return _pageRoute(
        PurchaseTypeLocalSearch(
          items: settings.arguments as List<PurchaseType>,
        ),
      );
  }

  return _pageRoute(
    Container(),
  );

}

MaterialPageRoute<T> _pageRoute<T>(Widget child, {ThemeData Function(BuildContext)? themeDataBuilder}) {

  return MaterialPageRoute<T>(
    builder: (BuildContext context) {
      return themeDataBuilder == null?
        child
        :
        Theme(
          data: themeDataBuilder(context),
          child: child,
        );
    },
  );

}