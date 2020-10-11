import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'route_constants.dart';
import 'connect.dart';
import 'homepage.dart';
import 'settings/settings.dart';
import 'detail/detail.dart';
import 'search/search.dart';
import 'statistics/statistics.dart';


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
      );

    case dlcDetailRoute:
      DetailArguments<DLC> detailArguments = settings.arguments as DetailArguments<DLC>;
      return _pageRoute(
        DLCDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
      );

    case purchaseDetailRoute:
      DetailArguments<Purchase> detailArguments = settings.arguments as DetailArguments<Purchase>;
      return _pageRoute(
        PurchaseDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
      );

    case storeDetailRoute:
      DetailArguments<Store> detailArguments = settings.arguments as DetailArguments<Store>;
      return _pageRoute(
        StoreDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
        ),
      );

    case platformDetailRoute:
      DetailArguments<Platform> detailArguments = settings.arguments as DetailArguments<Platform>;
      return _pageRoute(
        PlatformDetail(
          item: detailArguments.item,
          onUpdate: detailArguments.onUpdate,
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

  return _pageRoute(
    Container(),
  );

}

MaterialPageRoute<T> _pageRoute<T>(Widget child) {

  return MaterialPageRoute(
    builder: (BuildContext context) {
      return child;
    },
  );

}