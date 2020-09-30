import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class PlatformRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Platform, W> {

  PlatformRelationBloc({
    @required int platformID,
    @required PlatformBloc itemBloc,
  }) : super(itemID: platformID, itemBloc: itemBloc);

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
  Future<dynamic> addRelationFuture(AddItemRelation<Platform, W> event) {

    int platformID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGamePlatform(otherID, platformID);
      case System:
        return collectionRepository.insertPlatformSystem(platformID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<Platform, W> event) {

    int platformID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGamePlatform(otherID, platformID);
      case System:
        return collectionRepository.deletePlatformSystem(platformID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}