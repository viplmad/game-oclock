import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'item.dart';


class GameBloc extends ItemBloc {

  GameBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Game> createFuture(AddItem event) {

    return collectionRepository.insertGame(event.item != null? event.item.getTitle() : '', '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deleteGame(event.item.ID);

  }

  @override
  Future<Game> updateFuture(UpdateItemField event) {

    return collectionRepository.updateGame(event.item.ID, event.field, event.value);

  }

  @override
  Future<Game> updateImage(UpdateItemImage event) {

    return collectionRepository.uploadGameCover(event.item.ID, event.imagePath);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int gameID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case dlcTable:
        return collectionRepository.insertGameDLC(gameID, otherID);
      case purchaseTable:
        return collectionRepository.insertGamePurchase(gameID, otherID);
      case platformTable:
        return collectionRepository.insertGamePlatform(gameID, otherID);
      case tagTable:
        return collectionRepository.insertGameTag(gameID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int gameID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case dlcTable:
        return collectionRepository.deleteGameDLC(otherID);
      case purchaseTable:
        return collectionRepository.deleteGamePurchase(gameID, otherID);
      case platformTable:
        return collectionRepository.deleteGamePlatform(gameID, otherID);
      case tagTable:
        return collectionRepository.deleteGameTag(gameID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}