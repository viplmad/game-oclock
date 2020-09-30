import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class GameBloc extends ItemBloc<Game> {

  GameBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Game> createFuture(AddItem event) {

    return collectionRepository.insertGame(event.title ?? '', '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Game> event) {

    return collectionRepository.deleteGame(event.item.ID);

  }

  @override
  Future<Game> updateFuture(UpdateItemField<Game> event) {

    return collectionRepository.updateGame(event.item.ID, event.field, event.value);

  }

  @override
  Future<Game> addImage(AddItemImage<Game> event) {

    return collectionRepository.uploadGameCover(event.item.ID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Game> updateImageName(UpdateItemImageName<Game> event) {

    return collectionRepository.renameGameCover(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Game> deleteImage(DeleteItemImage<Game> event) {

    return collectionRepository.deleteGameCover(event.item.ID, event.imageName);

  }

  @override
  Future<dynamic> addRelationFuture<W extends CollectionItem>(AddItemRelation<Game, W> event) {

    int gameID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case DLC:
        return collectionRepository.insertGameDLC(gameID, otherID);
      case Purchase:
        return collectionRepository.insertGamePurchase(gameID, otherID);
      case Platform:
        return collectionRepository.insertGamePlatform(gameID, otherID);
      case Tag:
        return collectionRepository.insertGameTag(gameID, otherID);
    }

    return super.addRelationFuture<W>(event);

  }

  @override
  Future<dynamic> deleteRelationFuture<W extends CollectionItem>(DeleteItemRelation<Game, W> event) {

    int gameID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case DLC:
        return collectionRepository.deleteGameDLC(otherID);
      case Purchase:
        return collectionRepository.deleteGamePurchase(gameID, otherID);
      case Platform:
        return collectionRepository.deleteGamePlatform(gameID, otherID);
      case Tag:
        return collectionRepository.deleteGameTag(gameID, otherID);
    }

    return super.deleteRelationFuture<W>(event);

  }

}