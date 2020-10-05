import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import '../route_constants.dart';
import 'search.dart';


class GameSearch extends ItemSearch<Game, GameSearchBloc> {

  @override
  GameSearchBloc searchBlocBuilder() {

    return GameSearchBloc(
      iCollectionRepository: CollectionRepository(),
    );

  }

}

class GameLocalSearch extends ItemLocalSearch<Game> {

  GameLocalSearch({
    Key key,
    @required List<Game> items,
  }) : super(key: key, items: items);

  @override
  String detailRouteName = gameDetailRoute;


}