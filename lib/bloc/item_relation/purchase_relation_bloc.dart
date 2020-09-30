import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class PurchaseRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Purchase, W> {

  PurchaseRelationBloc({
    @required int purchaseID,
    @required PurchaseBloc itemBloc,
  }) : super(itemID: purchaseID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return collectionRepository.getGamesFromPurchase(itemID) as Stream<List<W>>;
      case DLC:
        return collectionRepository.getDLCsFromPurchase(itemID) as Stream<List<W>>;
      case Store:
        return collectionRepository.getStoreFromPurchase(itemID).map<List<Store>>( (Store store) => store != null? [store] : [] ) as Stream<List<W>>;
      case PurchaseType:
        return collectionRepository.getTypesFromPurchase(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<Purchase, W> event) {

    int purchaseID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
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
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<Purchase, W> event) {

    int purchaseID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
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