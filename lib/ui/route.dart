import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';
import 'package:game_collection/ui/assistant/time_log_assistant.dart';
import 'package:game_collection/ui/list/game_tag_list.dart';

import 'route_constants.dart';
import 'connect.dart';
import 'homepage.dart';
import 'settings/settings.dart';
import 'detail/detail.dart';
import 'search/search.dart';
import 'calendar/calendar.dart';
import 'statistics/statistics.dart';
import 'theme/theme.dart';

import 'detail/detail_arguments.dart';
import 'search/search_arguments.dart';
import 'calendar/calendar_arguments.dart';
import 'statistics/statistics_arguments.dart';

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
      final StatisticsArguments statisticsArguments = settings.arguments as StatisticsArguments;
      return _pageRoute(
        GameStatisticsView(
          viewIndex: statisticsArguments.viewIndex,
          viewYear: statisticsArguments.viewYear,
          viewTitle: statisticsArguments.viewTitle,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    /* case purchaseStatisticsRoute:
      final StatisticsArguments<Purchase> statisticsArguments = settings.arguments as StatisticsArguments<Purchase>;
      return _pageRoute(
        PurchaseStatistics(
          items: statisticsArguments.items,
          viewTitle: statisticsArguments.viewTitle,
        ),
        themeDataBuilder: PurchaseTheme.themeData,
      ); */

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
      final SearchArguments searchArguments = settings.arguments as SearchArguments;
      return _pageRoute<Game>(
        GameSearch(
          onTapReturn: searchArguments.onTapReturn,
          viewIndex: searchArguments.viewIndex,
          viewYear: searchArguments.viewYear,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case dlcSearchRoute:
      final SearchArguments searchArguments = settings.arguments as SearchArguments;
      return _pageRoute<DLC>(
        DLCSearch(
          onTapReturn: searchArguments.onTapReturn,
          viewIndex: searchArguments.viewIndex,
        ),
        themeDataBuilder: DLCTheme.themeData,
      );

    case purchaseSearchRoute:
      final SearchArguments searchArguments = settings.arguments as SearchArguments;
      return _pageRoute<Purchase>(
        PurchaseSearch(
          onTapReturn: searchArguments.onTapReturn,
          viewIndex: searchArguments.viewIndex,
          viewYear: searchArguments.viewYear,
        ),
        themeDataBuilder: PurchaseTheme.themeData,
      );

    case storeSearchRoute:
      final SearchArguments searchArguments = settings.arguments as SearchArguments;
      return _pageRoute<Store>(
        StoreSearch(
          onTapReturn: searchArguments.onTapReturn,
          viewIndex: searchArguments.viewIndex,
        ),
        themeDataBuilder: StoreTheme.themeData,
      );

    case platformSearchRoute:
      final SearchArguments searchArguments = settings.arguments as SearchArguments;
      return _pageRoute<Platform>(
        PlatformSearch(
          onTapReturn: searchArguments.onTapReturn,
          viewIndex: searchArguments.viewIndex,
        ),
        themeDataBuilder: PlatformTheme.themeData,
      );

    case systemSearchRoute:
      final SearchArguments searchArguments = settings.arguments as SearchArguments;
      return _pageRoute<System>(
        SystemSearch(
          onTapReturn: searchArguments.onTapReturn,
          viewIndex: searchArguments.viewIndex,
        ),
      );

    case gameTagSearchRoute:
      final SearchArguments searchArguments = settings.arguments as SearchArguments;
      return _pageRoute<GameTag>(
        GameTagSearch(
          onTapReturn: searchArguments.onTapReturn,
          viewIndex: searchArguments.viewIndex,
        ),
      );

    case purchaseTypeSearchRoute:
      final SearchArguments searchArguments = settings.arguments as SearchArguments;
      return _pageRoute<PurchaseType>(
        PurchaseTypeSearch(
          onTapReturn: searchArguments.onTapReturn,
          viewIndex: searchArguments.viewIndex,
        ),
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

    case timeLogAssistantRoute:
      return _pageRoute<GameTimeLog>(
        const TimeLogAssistant(),
        themeDataBuilder: GameTheme.themeData,
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