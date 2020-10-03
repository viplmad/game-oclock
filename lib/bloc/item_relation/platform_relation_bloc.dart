import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_relation.dart';


class PlatformRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Platform, W> {

  PlatformRelationBloc({
    @required int platformID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: platformID, collectionRepository: collectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return collectionRepository.getGamesFromPlatform(itemID) as Stream<List<W>>;
      case System:
        return collectionRepository.getSystemsFromPlatform(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGamePlatform(otherID, itemID);
      case System:
        return collectionRepository.insertPlatformSystem(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGamePlatform(otherID, itemID);
      case System:
        return collectionRepository.deletePlatformSystem(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}