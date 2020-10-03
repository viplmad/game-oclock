import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';

class GameSearchBloc extends ItemSearchBloc<Game> {

  GameSearchBloc({
    @required ICollectionRepository collectionRepository
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Game> createFuture(AddItem event) {

    return collectionRepository.insertGame(event.title ?? '', '');

  }

  @override
  Future<List<Game>> getInitialItems() {

    return collectionRepository.getGamesWithView(GameView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<Game>> getSearchItems(String query) {

    return collectionRepository.getGamesWithName(query, super.maxResults).first;

  }

}