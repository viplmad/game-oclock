import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'search.dart';


class GameSearch extends ItemSearch<Game, GameSearchBloc, GameListManagerBloc> {
  const GameSearch({
    Key key,
  }) : super(key: key);

  @override
  GameSearchBloc searchBlocBuilder() {

    return GameSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  GameListManagerBloc managerBlocBuilder() {

    return GameListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  _GameSearchBody<GameSearchBloc> itemSearchBodyBuilder({void Function() Function(BuildContext, Game) onTap, bool allowNewButton}) {

    return _GameSearchBody<GameSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class GameLocalSearch extends ItemLocalSearch<Game, GameListManagerBloc> {
  const GameLocalSearch({
    Key key,
    @required List<Game> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  GameListManagerBloc managerBlocBuilder() {

    return GameListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository,
    );

  }

  @override
  _GameSearchBody<ItemLocalSearchBloc<Game>> itemSearchBodyBuilder({void Function() Function(BuildContext, Game) onTap, bool allowNewButton}) {

    return _GameSearchBody<ItemLocalSearchBloc<Game>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _GameSearchBody<K extends ItemSearchBloc<Game>> extends ItemSearchBody<Game, K, GameListManagerBloc> {
  const _GameSearchBody({
    Key key,
    @required void Function() Function(BuildContext, Game) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).gamesString;

  @override
  Widget cardBuilder(BuildContext context, Game item) => GameTheme.itemCard(context, item, onTap);
}