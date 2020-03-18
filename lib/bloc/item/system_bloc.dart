import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class SystemBloc extends ItemBloc {

  SystemBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<System> createFuture(AddItem event) {

    return collectionRepository.insertSystem(event.item != null? event.item.getTitle() : '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deleteSystem(event.item.ID);

  }

  @override
  Future<System> updateFuture(UpdateItemField event) {

    return collectionRepository.updateSystem(event.item.ID, event.field, event.value);

  }

  @override
  Future<System> updateImage(UpdateItemImage event) {

    return collectionRepository.uploadSystemIcon(event.item.ID, event.imagePath);

  }

  @override
  Future<System> updateImageName(UpdateItemImageName event) {

    return collectionRepository.renameSystemIcon(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int systemID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case Platform:
        return collectionRepository.insertPlatformSystem(otherID, systemID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int systemID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case Platform:
        return collectionRepository.deletePlatformSystem(otherID, systemID);
    }

    return super.deleteRelationFuture(event);

  }

}