import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class GameRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Game, W> {

  GameRelationBloc({
    @required int gameID,
    @required GameBloc itemBloc,
  }) : super(itemID: gameID, itemBloc: itemBloc);

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
  Future<dynamic> addRelationFuture(AddItemRelation<Game, W> event) {

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

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<Game, W> event) {

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

    return super.deleteRelationFuture(event);

  }

}