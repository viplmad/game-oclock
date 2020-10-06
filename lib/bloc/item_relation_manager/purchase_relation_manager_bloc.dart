import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class PurchaseRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Purchase, W> {

  PurchaseRelationManagerBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

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