import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


class GameSearchBloc extends ItemSearchBloc<Game> {
  GameSearchBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<Game>> getInitialItems() {

    return iCollectionRepository!.findAllOwnedGamesWithView(GameView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Game>> getSearchItems(String query) {

    return iCollectionRepository!.findAllGamesByName(query, super.maxResults).first;

  }
}