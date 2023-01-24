import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart'
    show GameDTO, NewGameDTO, GameStatus, GameWithFinishDTO, GameWithLogDTO;

import 'package:backend/model/model.dart' show ListStyle, GameView;
import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import '../common/year_picker_dialog.dart';
import 'list.dart';

class GameAppBar extends ItemAppBar<GameDTO, GameListBloc> {
  const GameAppBar({
    Key? key,
  }) : super(
          key: key,
          themeColor: GameTheme.primaryColour,
          gridAllowed: GameTheme.hasImage,
          searchRouteName: gameSearchRoute,
          detailRouteName: gameDetailRoute,
          calendarRouteName: gameMultiCalendarRoute,
        );

  @override
  void Function(int) onSelected(BuildContext context, List<String> views) {
    return (int selectedViewIndex) async {
      if (selectedViewIndex == GameView.review.index) {
        final int? year = await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: GameTheme.themeData(context),
              child: const YearPickerDialog(),
            );
          },
        );

        if (year != null) {
          // Ignore because we will never get to use use unmounted context
          // ignore: use_build_context_synchronously
          BlocProvider.of<GameListBloc>(context)
              .add(UpdateView(selectedViewIndex, year));
        }
      } else {
        BlocProvider.of<GameListBloc>(context)
            .add(UpdateView(selectedViewIndex));
      }
    };
  }

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).gameString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).gamesString;

  @override
  List<String> views(BuildContext context) => GameTheme.views(context);
}

class GameFAB extends ItemFAB<GameDTO, NewGameDTO, GameListManagerBloc> {
  const GameFAB({
    Key? key,
  }) : super(
          key: key,
          themeColor: GameTheme.secondaryColour,
        );

  @override
  NewGameDTO createItem() =>
      NewGameDTO(name: '', edition: '', status: GameStatus.lowPriority);

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).gameString;
}

class GameList extends ItemList<GameDTO, GameListBloc, GameListManagerBloc> {
  const GameList({
    Key? key,
  }) : super(
          key: key,
          detailRouteName: gameDetailRoute,
        );

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).gameString;

  @override
  // ignore: library_private_types_in_public_api
  _GameListBody itemListBodyBuilder({
    required List<GameDTO> items,
    required int viewIndex,
    required Object? viewArgs,
    required void Function(GameDTO) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  }) {
    return _GameListBody(
      items: items,
      viewIndex: viewIndex,
      viewArgs: viewArgs,
      onDelete: onDelete,
      style: style,
      scrollController: scrollController,
    );
  }
}

class _GameListBody extends ItemListBody<GameDTO, GameListBloc> {
  const _GameListBody({
    Key? key,
    required super.items,
    required super.viewIndex,
    required super.viewArgs,
    required super.onDelete,
    required super.style,
    required super.scrollController,
  }) : super(
          key: key,
          detailRouteName: gameDetailRoute,
          searchRouteName: gameSearchRoute,
        );

  @override
  String itemTitle(GameDTO item) => GameTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) =>
      GameTheme.views(context).elementAt(viewIndex) +
      ((viewArgs != null && viewArgs is int)
          ? ' (${GameCollectionLocalisations.of(context).formatYear(viewArgs as int)})'
          : '');

  @override
  Widget cardBuilder(BuildContext context, GameDTO item) {
    if (item is GameWithFinishDTO) {
      return GameTheme.itemCardFinish(context, item, onTap);
    } else if (item is GameWithLogDTO) {
      return GameTheme.itemCardLog(context, item, onTap);
    }

    return GameTheme.itemCard(context, item, onTap);
  }

  @override
  Widget gridBuilder(BuildContext context, GameDTO item) =>
      GameTheme.itemGrid(context, item, onTap);
}
