import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../route_constants.dart';
import 'search.dart';


class GameSearch extends ItemSearch<Game, GameSearchBloc, GameListManagerBloc> {

  @override
  GameSearchBloc searchBlocBuilder() {

    return GameSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

  @override
  GameListManagerBloc managerBlocBuilder() {

    return GameListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class GameLocalSearch extends ItemLocalSearch<Game, GameListManagerBloc> {

  GameLocalSearch({
    Key key,
    @required List<Game> items,
  }) : super(key: key, items: items);

  @override
  String detailRouteName = gameDetailRoute;

  @override
  GameListManagerBloc managerBlocBuilder() {

    return GameListManagerBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }


}