import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'start.dart';
import 'homepage.dart';
import 'detail/detail.dart';
import 'search/search.dart';
import 'statistics/statistics.dart';

import 'route_constants.dart';


Route<dynamic> onGenerateRoute(RouteSettings settings) {

  switch(settings.name) {
    case startRoute:
      return _pageRoute(
        Startpage(),
      );

    case homeRoute:
      return _pageRoute(
        Homepage(),
      );

    case gameDetailRoute:
      return _pageRoute(
        GameDetail(
          item: settings.arguments as Game,
        ),
      );

    case dlcDetailRoute:
      return _pageRoute(
        DLCDetail(
          item: settings.arguments as DLC,
        ),
      );

    case purchaseDetailRoute:
      return _pageRoute(
        PurchaseDetail(
          item: settings.arguments as Purchase,
        ),
      );

    case storeDetailRoute:
      return _pageRoute(
        StoreDetail(
          item: settings.arguments as Store,
        ),
      );

    case platformDetailRoute:
      return _pageRoute(
        PlatformDetail(
          item: settings.arguments as Platform,
        ),
      );

    case gameSearchRoute:
      return _pageRoute<Game>(
        GameSearch(),
      );

    case dlcSearchRoute:
      return _pageRoute<DLC>(
        DLCSearch(),
      );

    case purchaseSearchRoute:
      return _pageRoute<Purchase>(
        PurchaseSearch(),
      );

    case storeSearchRoute:
      return _pageRoute<Store>(
        StoreSearch(),
      );

    case platformSearchRoute:
      return _pageRoute<Platform>(
        PlatformSearch(),
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
      );

    case dlcLocalSearchRoute:
      return _pageRoute(
        DLCLocalSearch(
          items: settings.arguments as List<DLC>,
        ),
      );

    case purchaseLocalSearchRoute:
      return _pageRoute(
        PurchaseLocalSearch(
          items: settings.arguments as List<Purchase>,
        ),
      );

    case storeLocalSearchRoute:
      return _pageRoute(
        StoreLocalSearch(
          items: settings.arguments as List<Store>,
        ),
      );

    case platformLocalSearchRoute:
      return _pageRoute(
        PlatformLocalSearch(
          items: settings.arguments as List<Platform>,
        ),
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

}

MaterialPageRoute<T> _pageRoute<T>(Widget child) {

  return MaterialPageRoute(
    builder: (BuildContext context) {
      return child;
    },
  );

}