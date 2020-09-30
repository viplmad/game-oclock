import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class PlatformBloc extends ItemBloc<Platform> {

  PlatformBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Platform> createFuture(AddItem event) {

    return collectionRepository.insertPlatform(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Platform> event) {

    return collectionRepository.deletePlatform(event.item.ID);

  }

  @override
  Future<Platform> updateFuture(UpdateItemField<Platform> event) {

    return collectionRepository.updatePlatform(event.item.ID, event.field, event.value);

  }

  @override
  Future<Platform> addImage(AddItemImage<Platform> event) {

    return collectionRepository.uploadPlatformIcon(event.item.ID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Platform> updateImageName(UpdateItemImageName<Platform> event) {

    return collectionRepository.renamePlatformIcon(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Platform> deleteImage(DeleteItemImage<Platform> event) {

    return collectionRepository.deletePlatformIcon(event.item.ID, event.imageName);

  }

  @override
  Future<dynamic> addRelationFuture<W extends CollectionItem>(AddItemRelation<Platform, W> event) {

    int platformID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGamePlatform(otherID, platformID);
      case System:
        return collectionRepository.insertPlatformSystem(platformID, otherID);
    }

    return super.addRelationFuture<W>(event);

  }

  @override
  Future<dynamic> deleteRelationFuture<W extends CollectionItem>(DeleteItemRelation<Platform, W> event) {

    int platformID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGamePlatform(otherID, platformID);
      case System:
        return collectionRepository.deletePlatformSystem(platformID, otherID);
    }

    return super.deleteRelationFuture<W>(event);

  }

}