import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

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
  Future<Game> addImage(AddItemImage event) {

    return collectionRepository.uploadGameCover(event.item.ID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Game> updateImageName(UpdateItemImageName event) {

    return collectionRepository.renameGameCover(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Game> deleteImage(DeleteItemImage event) {

    return collectionRepository.deleteGameCover(event.item.ID, event.imageName);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int gameID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case DLC:
        return collectionRepository.insertGameDLC(gameID, otherID);
      case Purchase:
        return collectionRepository.insertGamePurchase(gameID, otherID);
      case Platform:
        return collectionRepository.insertGamePlatform(gameID, otherID);
      case Tag:
        return collectionRepository.insertGameTag(gameID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int gameID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case DLC:
        return collectionRepository.deleteGameDLC(otherID);
      case Purchase:
        return collectionRepository.deleteGamePurchase(gameID, otherID);
      case Platform:
        return collectionRepository.deleteGamePlatform(gameID, otherID);
      case Tag:
        return collectionRepository.deleteGameTag(gameID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}