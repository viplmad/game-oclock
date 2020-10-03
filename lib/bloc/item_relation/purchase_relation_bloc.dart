import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_relation.dart';


class PurchaseRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Purchase, W> {

  PurchaseRelationBloc({
    @required int purchaseID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: purchaseID, collectionRepository: collectionRepository);

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
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGamePurchase(otherID, itemID);
      case DLC:
        return collectionRepository.insertDLCPurchase(otherID, itemID);
      case Store:
        return collectionRepository.insertStorePurchase(otherID, itemID);
      case PurchaseType:
        return collectionRepository.insertPurchaseType(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGamePurchase(otherID, itemID);
      case DLC:
        return collectionRepository.deleteDLCPurchase(otherID, itemID);
      case Store:
        return collectionRepository.deleteStorePurchase(itemID);
      case PurchaseType:
        return collectionRepository.deletePurchaseType(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}