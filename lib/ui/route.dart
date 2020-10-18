import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'route_constants.dart';
import 'connect.dart';
import 'homepage.dart';
import 'settings/settings.dart';
import 'detail/detail.dart';
import 'search/search.dart';
import 'statistics/statistics.dart';
import 'theme/theme.dart';


Route<dynamic> onGenerateRoute(RouteSettings settings) {

  switch(settings.name) {
    case connectRoute:
      return _pageRoute(
        Connectpage(),
      );

    case homeRoute:
      return _pageRoute(
        Homepage(),
      );

    case repositorySettingsRoute:
      return _pageRoute(
        RepositorySettings(),
      );

    case gameDetailRoute:
      DetailArguments<Game> detailArguments = settings.arguments as DetailArguments<Game>;
      return _pageRoute(
        GameDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case dlcDetailRoute:
      DetailArguments<DLC> detailArguments = settings.arguments as DetailArguments<DLC>;
      return _pageRoute(
        DLCDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: DLCTheme.themeData,
      );

    case purchaseDetailRoute:
      DetailArguments<Purchase> detailArguments = settings.arguments as DetailArguments<Purchase>;
      return _pageRoute(
        PurchaseDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: PurchaseTheme.themeData,
      );

    case storeDetailRoute:
      DetailArguments<Store> detailArguments = settings.arguments as DetailArguments<Store>;
      return _pageRoute(
        StoreDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: StoreTheme.themeData,
      );

    case platformDetailRoute:
      DetailArguments<Platform> detailArguments = settings.arguments as DetailArguments<Platform>;
      return _pageRoute(
        PlatformDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
        themeDataBuilder: PlatformTheme.themeData,
      );

    case gameStatisticsRoute:
      GameStatisticsArguments statisticsArguments = settings.arguments as GameStatisticsArguments;
      return _pageRoute(
        GameStatistics(
          items: statisticsArguments.items,
          viewTitle: statisticsArguments.viewTitle,
          tabTitle: statisticsArguments.tabTitle,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case purchaseStatisticsRoute:
      StatisticsArguments<Purchase> statisticsArguments = settings.arguments as StatisticsArguments<Purchase>;
      return _pageRoute(
        PurchaseStatistics(
          items: statisticsArguments.items,
          viewTitle: statisticsArguments.viewTitle,
        ),
        themeDataBuilder: PurchaseTheme.themeData,
      );

    case gameSearchRoute:
      return _pageRoute<Game>(
        GameSearch(),
        themeDataBuilder: GameTheme.themeData,
      );

    case dlcSearchRoute:
      return _pageRoute<DLC>(
        DLCSearch(),
        themeDataBuilder: DLCTheme.themeData,
      );

    case purchaseSearchRoute:
      return _pageRoute<Purchase>(
        PurchaseSearch(),
        themeDataBuilder: PurchaseTheme.themeData,
      );

    case storeSearchRoute:
      return _pageRoute<Store>(
        StoreSearch(),
        themeDataBuilder: StoreTheme.themeData,
      );

    case platformSearchRoute:
      return _pageRoute<Platform>(
        PlatformSearch(),
        themeDataBuilder: PlatformTheme.themeData,
      );

    case systemSearchRoute:
      return _pageRoute<System>(
        SystemSearch(),
      );

    case tagSearchRoute:
      return _pageRoute<Tag>(
        TagSearch(),
      );

    case typeSearchRoute:
      return _pageRoute<PurchaseType>(
        TypeSearch(),
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

    case tagLocalSearchRoute:
      return _pageRoute(
        TagLocalSearch(
          items: settings.arguments as List<Tag>,
        ),
      );

    case typeLocalSearchRoute:
      return _pageRoute(
        TypeLocalSearch(
          items: settings.arguments as List<PurchaseType>,
        ),
      );
  }

  return _pageRoute(
    Container(),
  );

}

MaterialPageRoute<T> _pageRoute<T>(Widget child, {ThemeData Function(BuildContext) themeDataBuilder}) {

  return MaterialPageRoute(
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