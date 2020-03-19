import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class StoreBloc extends ItemBloc {

  StoreBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Store> createFuture(AddItem event) {

    return collectionRepository.insertStore(event.item != null? event.item.getTitle() : '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deleteStore(event.item.ID);

  }

  @override
  Future<Store> updateFuture(UpdateItemField event) {

    return collectionRepository.updateStore(event.item.ID, event.field, event.value);

  }

  @override
  Future<Store> addImage(AddItemImage event) {

    return collectionRepository.uploadStoreIcon(event.item.ID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Store> updateImageName(UpdateItemImageName event) {

    return collectionRepository.renameStoreIcon(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Store> deleteImage(DeleteItemImage event) {

    return collectionRepository.deleteStoreIcon(event.item.ID, event.imageName);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int storeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case Purchase:
        return collectionRepository.insertStorePurchase(storeID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int storeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case Purchase:
        return collectionRepository.deleteStorePurchase(otherID);
    }

    return super.deleteRelationFuture(event);

  }

}