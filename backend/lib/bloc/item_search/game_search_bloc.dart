import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_search.dart';


class GameSearchBloc extends ItemSearchBloc<Game> {
  GameSearchBloc({
    required CollectionRepository iCollectionRepository,
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