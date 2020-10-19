import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class PurchaseRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Purchase, W> {
  PurchaseRelationManagerBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.relateGamePurchase(otherId, itemId);
      case DLC:
        return iCollectionRepository.relateDLCPurchase(otherId, itemId);
      case Store:
        return iCollectionRepository.relateStorePurchase(otherId, itemId);
      case PurchaseType:
        return iCollectionRepository.relatePurchaseType(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.deleteGamePurchase(otherId, itemId);
      case DLC:
        return iCollectionRepository.deleteDLCPurchase(otherId, itemId);
      case Store:
        return iCollectionRepository.deleteStorePurchase(itemId);
      case PurchaseType:
        return iCollectionRepository.deletePurchaseType(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}