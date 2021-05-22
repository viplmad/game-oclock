import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class PurchaseRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Purchase, W> {
  PurchaseRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

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

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.unrelateGamePurchase(otherId, itemId);
      case DLC:
        return iCollectionRepository.unrelateDLCPurchase(otherId, itemId);
      case Store:
        return iCollectionRepository.unrelateStorePurchase(itemId);
      case PurchaseType:
        return iCollectionRepository.unrelatePurchaseType(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}