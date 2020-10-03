import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation.dart';


class PlatformRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Platform, W> {

  PlatformRelationBloc({
    @required int platformID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: platformID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.getGamesFromPlatform(itemID) as Stream<List<W>>;
      case System:
        return iCollectionRepository.getSystemsFromPlatform(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.insertGamePlatform(otherID, itemID);
      case System:
        return iCollectionRepository.insertPlatformSystem(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.deleteGamePlatform(otherID, itemID);
      case System:
        return iCollectionRepository.deletePlatformSystem(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}