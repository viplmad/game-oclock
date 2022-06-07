import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show Game, GameStatus;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;
import 'search.dart';

class GameSearch extends ItemSearch<Game, GameSearchBloc, GameListManagerBloc> {
  const GameSearch({
    Key? key,
    required super.onTapReturn,
    required super.viewIndex,
    this.viewYear,
  }) : super(
          key: key,
          detailRouteName: gameDetailRoute,
        );

  final int? viewYear;

  @override
  GameSearchBloc searchBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return GameSearchBloc(
      collectionRepository: collectionRepository,
      viewIndex: viewIndex,
      viewYear: viewYear,
    );
  }

  @override
  GameListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return GameListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _GameSearchBody<GameSearchBloc> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, Game) onTap,
    required bool allowNewButton,
  }) {
    return _GameSearchBody<GameSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class GameLocalSearch extends ItemLocalSearch<Game, GameListManagerBloc> {
  const GameLocalSearch({
    Key? key,
    required super.items,
  }) : super(
          key: key,
          detailRouteName: gameDetailRoute,
        );

  @override
  GameListManagerBloc managerBlocBuilder(
    GameCollectionRepository collectionRepository,
  ) {
    return GameListManagerBloc(
      collectionRepository: collectionRepository,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _GameSearchBody<ItemLocalSearchBloc<Game>> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, Game) onTap,
    required bool allowNewButton,
  }) {
    return _GameSearchBody<ItemLocalSearchBloc<Game>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );
  }
}

class _GameSearchBody<K extends ItemSearchBloc<Game>>
    extends ItemSearchBody<Game, K, GameListManagerBloc> {
  const _GameSearchBody({
    Key? key,
    required super.onTap,
    super.allowNewButton = false,
  }) : super(key: key);

  @override
  String typeName(BuildContext context) =>
      GameCollectionLocalisations.of(context).gameString;

  @override
  String typesName(BuildContext context) =>
      GameCollectionLocalisations.of(context).gamesString;

  @override
  Game createItem(String query) => Game(
        id: -1,
        name: query,
        edition: '',
        releaseYear: null,
        coverURL: null,
        coverFilename: null,
        status: GameStatus.lowPriority,
        rating: 0,
        thoughts: '',
        saveFolder: '',
        screenshotFolder: '',
        isBackup: false,
        firstFinishDate: null,
        totalTime: const Duration(),
      );

  @override
  Widget cardBuilder(BuildContext context, Game item) =>
      GameTheme.itemCard(context, item, onTap);
}
