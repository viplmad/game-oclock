import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_list.dart';


class GameListBloc extends ItemListBloc<Game> {

  GameListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<Game>> getReadAllStream() {

    return collectionRepository.getAllGames();

  }

  @override
  Future<Game> createFuture(AddItem event) {

    return collectionRepository.insertGame(event.title ?? '', '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Game> event) {

    return collectionRepository.deleteGame(event.item.ID);

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    GameView gameView = GameView.values[event.viewIndex];

    return collectionRepository.getGamesWithView(gameView);

  }

}