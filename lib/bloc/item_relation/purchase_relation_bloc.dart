import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation.dart';


class PurchaseRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Purchase, W> {

  PurchaseRelationBloc({
    @required int purchaseID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: purchaseID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.getGamesFromPurchase(itemID) as Stream<List<W>>;
      case DLC:
        return iCollectionRepository.getDLCsFromPurchase(itemID) as Stream<List<W>>;
      case Store:
        return iCollectionRepository.getStoreFromPurchase(itemID).map<List<Store>>( (Store store) => store != null? [store] : [] ) as Stream<List<W>>;
      case PurchaseType:
        return iCollectionRepository.getTypesFromPurchase(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.insertGamePurchase(otherID, itemID);
      case DLC:
        return iCollectionRepository.insertDLCPurchase(otherID, itemID);
      case Store:
        return iCollectionRepository.insertStorePurchase(otherID, itemID);
      case PurchaseType:
        return iCollectionRepository.insertPurchaseType(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.deleteGamePurchase(otherID, itemID);
      case DLC:
        return iCollectionRepository.deleteDLCPurchase(otherID, itemID);
      case Store:
        return iCollectionRepository.deleteStorePurchase(itemID);
      case PurchaseType:
        return iCollectionRepository.deletePurchaseType(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}