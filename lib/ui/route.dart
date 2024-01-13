import 'package:flutter/material.dart';

import 'package:game_oclock_client/api.dart'
    show DLCDTO, GameDTO, NewGameLogDTO, PlatformDTO, TagDTO;

import 'assistant/time_log_assistant.dart';
import 'list/list.dart';
import 'route_constants.dart';
import 'connect.dart';
import 'homepage.dart';
import 'settings/settings.dart';
import 'detail/detail.dart';
import 'search/search.dart';
import 'calendar/calendar.dart';
import 'review/review.dart';
import 'theme/theme.dart';

import 'detail/detail_arguments.dart';
import 'search/search_arguments.dart';
import 'calendar/calendar_arguments.dart';
import 'review/review_arguments.dart';

export 'route_constants.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case connectRoute:
      return _pageRoute(
        const Connectpage(),
      );

    case homeRoute:
      return _pageRoute(
        const Homepage(),
      );

    case serverSettingsRoute:
      return _pageRoute(
        const ServerSettings(),
      );

    case gameDetailRoute:
      final DetailArguments<GameDTO> detailArguments =
          settings.arguments as DetailArguments<GameDTO>;
      return _pageRoute(
        GameDetail(
          item: detailArguments.item,
          onChange: detailArguments.onChange,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case dlcDetailRoute:
      final DetailArguments<DLCDTO> detailArguments =
          settings.arguments as DetailArguments<DLCDTO>;
      return _pageRoute(
        DLCDetail(
          item: detailArguments.item,
          onChange: detailArguments.onChange,
        ),
        themeDataBuilder: DLCTheme.themeData,
      );

    case platformDetailRoute:
      final DetailArguments<PlatformDTO> detailArguments =
          settings.arguments as DetailArguments<PlatformDTO>;
      return _pageRoute(
        PlatformDetail(
          item: detailArguments.item,
          onChange: detailArguments.onChange,
        ),
        themeDataBuilder: PlatformTheme.themeData,
      );

    case tagDetailRoute:
      final DetailArguments<TagDTO> detailArguments =
          settings.arguments as DetailArguments<TagDTO>;
      return _pageRoute(
        GameTagDetail(
          item: detailArguments.item,
          onChange: detailArguments.onChange,
        ),
        themeDataBuilder: TagTheme.themeData,
      );

    case tagListRoute:
      return _pageRoute(
        const TagList(),
        themeDataBuilder: TagTheme.themeData,
      );

    case gameWishlistedListRoute:
      return _pageRoute(
        const GameWishlistedList(),
        themeDataBuilder: GameTheme.themeData,
      );

    case gameSingleCalendarRoute:
      final SingleGameCalendarArguments gameCalendarArguments =
          settings.arguments as SingleGameCalendarArguments;
      return _pageRoute(
        SingleGameCalendar(
          itemId: gameCalendarArguments.itemId,
          onChange: gameCalendarArguments.onChange,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case gameMultiCalendarRoute:
      return _pageRoute(
        const MultiGameCalendar(),
        themeDataBuilder: GameTheme.themeData,
      );

    case reviewYearRoute:
      final ReviewArguments reviewArguments =
          settings.arguments as ReviewArguments;
      return _pageRoute(
        ReviewYear(
          year: reviewArguments.year,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case gameSearchRoute:
      final SearchArguments searchArguments =
          settings.arguments as SearchArguments;
      return _pageRoute<GameDTO>(
        GameSearch(
          onTapReturn: searchArguments.onTapReturn,
        ),
        themeDataBuilder: GameTheme.themeData,
      );

    case dlcSearchRoute:
      final SearchArguments searchArguments =
          settings.arguments as SearchArguments;
      return _pageRoute<DLCDTO>(
        DLCSearch(
          onTapReturn: searchArguments.onTapReturn,
        ),
        themeDataBuilder: DLCTheme.themeData,
      );

    case platformSearchRoute:
      final SearchArguments searchArguments =
          settings.arguments as SearchArguments;
      return _pageRoute<PlatformDTO>(
        PlatformSearch(
          onTapReturn: searchArguments.onTapReturn,
        ),
        themeDataBuilder: PlatformTheme.themeData,
      );

    case tagSearchRoute:
      final SearchArguments searchArguments =
          settings.arguments as SearchArguments;
      return _pageRoute<TagDTO>(
        GameTagSearch(
          onTapReturn: searchArguments.onTapReturn,
        ),
      );

    case gameWishlistedSearchRoute:
      final SearchArguments searchArguments =
          settings.arguments as SearchArguments;
      return _pageRoute<GameDTO>(
        GameWishlistedSearch(
          onTapReturn: searchArguments.onTapReturn,
        ),
      );

    case gameLogAssistantRoute:
      return _pageRoute<NewGameLogDTO>(
        const GameLogAssistant(),
        themeDataBuilder: GameTheme.themeData,
      );
  }

  return _pageRoute(
    const SizedBox(),
  );
}

MaterialPageRoute<T> _pageRoute<T>(
  Widget child, {
  ThemeData Function(BuildContext)? themeDataBuilder,
}) {
  return MaterialPageRoute<T>(
    builder: (BuildContext context) {
      return themeDataBuilder == null
          ? child
          : Theme(
              data: themeDataBuilder(context),
              child: child,
            );
    },
  );
}
