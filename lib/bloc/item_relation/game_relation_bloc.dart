import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_relation.dart';


class GameRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Game, W> {

  GameRelationBloc({
    @required int gameID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: gameID, collectionRepository: collectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case DLC:
        return collectionRepository.getDLCsFromGame(itemID) as Stream<List<W>>;
      case Purchase:
        return collectionRepository.getPurchasesFromGame(itemID) as Stream<List<W>>;
      case Platform:
        return collectionRepository.getPlatformsFromGame(itemID) as Stream<List<W>>;
      case Tag:
        return collectionRepository.getTagsFromGame(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case DLC:
        return collectionRepository.insertGameDLC(itemID, otherID);
      case Purchase:
        return collectionRepository.insertGamePurchase(itemID, otherID);
      case Platform:
        return collectionRepository.insertGamePlatform(itemID, otherID);
      case Tag:
        return collectionRepository.insertGameTag(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case DLC:
        return collectionRepository.deleteGameDLC(otherID);
      case Purchase:
        return collectionRepository.deleteGamePurchase(itemID, otherID);
      case Platform:
        return collectionRepository.deleteGamePlatform(itemID, otherID);
      case Tag:
        return collectionRepository.deleteGameTag(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}