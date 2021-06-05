import 'package:flutter/material.dart';

import 'package:backend/model/model.dart';

import 'package:backend/repository/repository.dart';

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'search.dart';


class GameSearch extends ItemSearch<Game, GameSearchBloc, GameListManagerBloc> {
  const GameSearch({
    Key? key,
  }) : super(key: key);

  @override
  GameSearchBloc searchBlocBuilder() {

    return GameSearchBloc(
      iCollectionRepository: CollectionRepository.iCollectionRepository!,
    );

  }

  @override
  GameListManagerBloc managerBlocBuilder() {

    return GameListManagerBloc(
      iCollectionRepository: CollectionRepository.iCollectionRepository!,
    );

  }

  @override
  _GameSearchBody<GameSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, Game) onTap, required bool allowNewButton}) {

    return _GameSearchBody<GameSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class GameLocalSearch extends ItemLocalSearch<Game, GameListManagerBloc> {
  const GameLocalSearch({
    Key? key,
    required List<Game> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  GameListManagerBloc managerBlocBuilder() {

    return GameListManagerBloc(
      iCollectionRepository: CollectionRepository.iCollectionRepository!,
    );

  }

  @override
  _GameSearchBody<ItemLocalSearchBloc<Game>> itemSearchBodyBuilder({required void Function() Function(BuildContext, Game) onTap, required bool allowNewButton}) {

    return _GameSearchBody<ItemLocalSearchBloc<Game>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _GameSearchBody<K extends ItemSearchBloc<Game>> extends ItemSearchBody<Game, K, GameListManagerBloc> {
  const _GameSearchBody({
    Key? key,
    required void Function() Function(BuildContext, Game) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).gamesString;

  @override
  Game createItem(String query) => Game(id: -1, name: query, edition: '', releaseYear: null, coverURL: null, coverFilename: null, status: /* TODO */ 'Low Priority', rating: 0, thoughts: '', time: const Duration(), saveFolder: '', screenshotFolder: '', finishDate: null, isBackup: false);

  @override
  Widget cardBuilder(BuildContext context, Game item) => GameTheme.itemCard(context, item, onTap);
}