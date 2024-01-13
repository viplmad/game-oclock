import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:game_oclock_client/api.dart'
    show GameDTO, GameStatus, NewGameDTO;

import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_search/item_search.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import 'search.dart';

class GameWishlistedSearch extends ItemSearch<GameDTO, NewGameDTO,
    GameSearchBloc, GameListManagerBloc> {
  const GameWishlistedSearch({
    Key? key,
    required super.onTapReturn,
  }) : super(
          key: key,
          detailRouteName: gameDetailRoute,
        );

  @override
  GameSearchBloc searchBlocBuilder(
    GameOClockService collectionService,
  ) {
    return GameSearchBloc(
      collectionService: collectionService,
    );
  }

  @override
  GameListManagerBloc managerBlocBuilder(
    GameOClockService collectionService,
  ) {
    return GameListManagerBloc(
      collectionService: collectionService,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _GameWishlistedSearchBody itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, GameDTO) onTap,
    required bool allowNewButton,
  }) {
    return _GameWishlistedSearchBody(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _GameWishlistedSearchBody extends ItemSearchBody<GameDTO, NewGameDTO,
    GameSearchBloc, GameListManagerBloc> {
  const _GameWishlistedSearchBody({
    Key? key,
    required super.onTap,
    super.allowNewButton = false,
  }) : super(key: key);

  @override
  String typeName(BuildContext context) =>
      AppLocalizations.of(context)!.wishedGameString;

  @override
  String typesName(BuildContext context) =>
      AppLocalizations.of(context)!.gamesString;

  @override
  NewGameDTO createItem(String query) =>
      NewGameDTO(name: query, status: GameStatus.wishlist);

  @override
  Widget cardBuilder(BuildContext context, GameDTO item) =>
      GameTheme.itemCard(context, item, onTap);
}
