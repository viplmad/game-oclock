import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class PlatformBloc extends ItemBloc {

  PlatformBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Platform> createFuture(AddItem event) {

    return collectionRepository.insertPlatform(event.item != null? event.item.getTitle() : '');

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
  Future<Platform> updateImage(UpdateItemImage event) {

    return collectionRepository.uploadPlatformIcon(event.item.ID, event.imagePath);

  }

  @override
  Future<Platform> updateImageName(UpdateItemImageName event) {

    return collectionRepository.renamePlatformIcon(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int platformID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case Game:
        return collectionRepository.insertGamePlatform(otherID, platformID);
      case System:
        return collectionRepository.insertPlatformSystem(platformID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int platformID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case Game:
        return collectionRepository.deleteGamePlatform(otherID, platformID);
      case System:
        return collectionRepository.deletePlatformSystem(platformID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}