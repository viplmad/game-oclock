import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class DLCBloc extends ItemBloc<DLC> {

  DLCBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<DLC> createFuture(AddItem event) {

    return collectionRepository.insertDLC(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<DLC> event) {

    return collectionRepository.deleteDLC(event.item.ID);

  }

  @override
  Future<DLC> updateFuture(UpdateItemField<DLC> event) {

    return collectionRepository.updateDLC(event.item.ID, event.field, event.value);

  }

  @override
  Future<DLC> addImage(AddItemImage<DLC> event) {

    return collectionRepository.uploadDLCCover(event.item.ID, event.imagePath, event.oldImageName);

  }

  @override
  Future<DLC> updateImageName(UpdateItemImageName<DLC> event) {

    return collectionRepository.renameDLCCover(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<DLC> deleteImage(DeleteItemImage<DLC> event) {

    return collectionRepository.deleteDLCCover(event.item.ID, event.imageName);

  }

  @override
  Future<dynamic> addRelationFuture<W extends CollectionItem>(AddItemRelation<DLC, W> event) {

    int dlcID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGameDLC(otherID, dlcID);
      case Purchase:
        return collectionRepository.insertDLCPurchase(dlcID, otherID);
    }

    return super.addRelationFuture<W>(event);

  }

  @override
  Future<dynamic> deleteRelationFuture<W extends CollectionItem>(DeleteItemRelation<DLC, W> event) {

    int dlcID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGameDLC(dlcID);
      case Purchase:
        return collectionRepository.deleteDLCPurchase(dlcID, otherID);
    }

    return super.deleteRelationFuture<W>(event);

  }

}