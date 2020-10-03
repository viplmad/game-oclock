import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation.dart';


class GameRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Game, W> {

  GameRelationBloc({
    @required int gameID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: gameID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case DLC:
        return iCollectionRepository.getDLCsFromGame(itemID) as Stream<List<W>>;
      case Purchase:
        return iCollectionRepository.getPurchasesFromGame(itemID) as Stream<List<W>>;
      case Platform:
        return iCollectionRepository.getPlatformsFromGame(itemID) as Stream<List<W>>;
      case Tag:
        return iCollectionRepository.getTagsFromGame(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case DLC:
        return iCollectionRepository.insertGameDLC(itemID, otherID);
      case Purchase:
        return iCollectionRepository.insertGamePurchase(itemID, otherID);
      case Platform:
        return iCollectionRepository.insertGamePlatform(itemID, otherID);
      case Tag:
        return iCollectionRepository.insertGameTag(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case DLC:
        return iCollectionRepository.deleteGameDLC(otherID);
      case Purchase:
        return iCollectionRepository.deleteGamePurchase(itemID, otherID);
      case Platform:
        return iCollectionRepository.deleteGamePlatform(itemID, otherID);
      case Tag:
        return iCollectionRepository.deleteGameTag(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}