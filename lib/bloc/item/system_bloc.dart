import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class SystemBloc extends ItemBloc<System> {

  SystemBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<System> createFuture(AddItem event) {

    return collectionRepository.insertSystem(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<System> event) {

    return collectionRepository.deleteSystem(event.item.ID);

  }

  @override
  Future<System> updateFuture(UpdateItemField<System> event) {

    return collectionRepository.updateSystem(event.item.ID, event.field, event.value);

  }

  @override
  Future<System> addImage(AddItemImage<System> event) {

    return collectionRepository.uploadSystemIcon(event.item.ID, event.imagePath, event.oldImageName);

  }

  @override
  Future<System> updateImageName(UpdateItemImageName<System> event) {

    return collectionRepository.renameSystemIcon(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<System> deleteImage(DeleteItemImage<System> event) {

    return collectionRepository.deleteSystemIcon(event.item.ID, event.imageName);

  }

  @override
  Future<dynamic> addRelationFuture<W extends CollectionItem>(AddItemRelation<System, W> event) {

    int systemID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Platform:
        return collectionRepository.insertPlatformSystem(otherID, systemID);
    }

    return super.addRelationFuture<W>(event);

  }

  @override
  Future<dynamic> deleteRelationFuture<W extends CollectionItem>(DeleteItemRelation<System, W> event) {

    int systemID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Platform:
        return collectionRepository.deletePlatformSystem(otherID, systemID);
    }

    return super.deleteRelationFuture<W>(event);

  }

}