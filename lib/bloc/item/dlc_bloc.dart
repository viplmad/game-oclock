import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/dlc.dart';

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
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int dlcID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case gameTable:
        return collectionRepository.insertGameDLC(otherID, dlcID);
      case purchaseTable:
        return collectionRepository.insertDLCPurchase(dlcID, otherID);
    }

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

  }

}