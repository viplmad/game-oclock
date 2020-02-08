import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/game.dart';

import 'item.dart';


class GameBloc extends ItemBloc {

  GameBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Game> createFuture() {

    return collectionRepository.insertGame('', '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deleteGame(event.item.ID);

  }

  @override
  Future<Game> updateFuture(UpdateItemField event) {

    return collectionRepository.updateGame(event.item.ID, event.field, event.value);

  }

}