import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'item.dart';


class PlatformBloc extends ItemBloc {

  PlatformBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Platform> createFuture() {

    return collectionRepository.insertPlatform('');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deletePlatform(event.item.ID);

  }

  @override
  Future<Platform> updateFuture(UpdateItemField event) {

    return collectionRepository.updatePlatform(event.item.ID, event.field, event.value);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int platformID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case gameTable:
        return collectionRepository.insertGamePlatform(otherID, platformID);
      case systemTable:
        return collectionRepository.insertPlatformSystem(platformID, otherID);
    }

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int platformID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case gameTable:
        return collectionRepository.deleteGamePlatform(otherID, platformID);
      case systemTable:
        return collectionRepository.deletePlatformSystem(platformID, otherID);
    }

  }

}