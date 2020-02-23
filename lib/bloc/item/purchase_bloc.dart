import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class PurchaseBloc extends ItemBloc {

  PurchaseBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Purchase> createFuture(AddItem event) {

    return collectionRepository.insertPurchase(event.item != null? event.item.getTitle() : '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deletePurchase(event.item.ID);

  }

  @override
  Future<Purchase> updateFuture(UpdateItemField event) {
    
    return collectionRepository.updatePurchase(event.item.ID, event.field, event.value);
    
  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int purchaseID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case Game:
        return collectionRepository.insertGamePurchase(otherID, purchaseID);
      case DLC:
        return collectionRepository.insertDLCPurchase(otherID, purchaseID);
      case Store:
        return collectionRepository.insertStorePurchase(otherID, purchaseID);
      case PurchaseType:
        return collectionRepository.insertPurchaseType(purchaseID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int purchaseID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.type) {
      case Game:
        return collectionRepository.deleteGamePurchase(otherID, purchaseID);
      case DLC:
        return collectionRepository.deleteDLCPurchase(otherID, purchaseID);
      case Store:
        return collectionRepository.deleteStorePurchase(purchaseID);
      case PurchaseType:
        return collectionRepository.deletePurchaseType(purchaseID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}