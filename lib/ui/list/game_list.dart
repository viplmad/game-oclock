import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart'
    show GameDTO, NewGameDTO, GameStatus, GameWithFinishDTO, GameWithLogDTO;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/bloc/item_list/item_list.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import 'list.dart';

class GameAppBar extends ItemAppBar<GameDTO, GameListBloc> {
  const GameAppBar({
    super.key,
  }) : super(
          themeColor: GameTheme.primaryColour,
          gridAllowed: GameTheme.hasImage,
          searchRouteName: gameSearchRoute,
          detailRouteName: gameDetailRoute,
          calendarRouteName: gameMultiCalendarRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.gameString;

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.gamesString;

  @override
  List<String> views(BuildContext context) => GameTheme.views(context);
}

class GameFAB extends ItemFAB<GameDTO, NewGameDTO, GameListManagerBloc> {
  const GameFAB({
    super.key,
  }) : super(
          themeColor: GameTheme.secondaryColour,
        );

  @override
  NewGameDTO createItem() =>
      NewGameDTO(name: '', edition: '', status: GameStatus.lowPriority);

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.gameString;
}

class GameList extends ItemList<GameDTO, GameListBloc, GameListManagerBloc> {
  const GameList({
    super.key,
  }) : super(
          detailRouteName: gameDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.gameString;

  @override
  // ignore: library_private_types_in_public_api
  _GameListBody itemListBodyBuilder({
    required List<GameDTO> items,
    required int viewIndex,
    required void Function(GameDTO) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _GameListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _GameListBody extends ItemListBody<GameDTO, GameListBloc> {
  const _GameListBody({
    required super.items,
    required super.viewIndex,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          detailRouteName: gameDetailRoute,
        );

  @override
  String itemTitle(GameDTO item) => GameTheme.itemTitle(item);

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.gamesString;

  @override
  String viewTitle(BuildContext context) =>
      GameTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, GameDTO item) {
    if (item is GameWithFinishDTO) {
      return GameTheme.itemCardFinish(context, item, onTap);
    } else if (item is GameWithLogDTO) {
      return GameTheme.itemCardLog(context, item, onTap, isLastPlayed: true);
    }

    return GameTheme.itemCard(context, item, onTap);
  }

  @override
  Widget gridBuilder(BuildContext context, GameDTO item) =>
      GameTheme.itemGrid(context, item, onTap);
}
