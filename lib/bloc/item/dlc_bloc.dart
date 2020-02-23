import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'item.dart';


class DLCBloc extends ItemBloc {

  DLCBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<DLC> createFuture() {

    return collectionRepository.insertDLC('');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deleteDLC(event.item.ID);

  }

  @override
  Future<DLC> updateFuture(UpdateItemField event) {

    return collectionRepository.updateDLC(event.item.ID, event.field, event.value);

  }

  @override
  Future<DLC> updateImage(UpdateItemImage event) {

    return collectionRepository.uploadDLCCover(event.item.ID, event.imagePath);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int dlcID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case gameTable:
        return collectionRepository.insertGameDLC(otherID, dlcID);
      case purchaseTable:
        return collectionRepository.insertDLCPurchase(dlcID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int dlcID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case gameTable:
        return collectionRepository.deleteGameDLC(dlcID);
      case purchaseTable:
        return collectionRepository.deleteDLCPurchase(dlcID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}