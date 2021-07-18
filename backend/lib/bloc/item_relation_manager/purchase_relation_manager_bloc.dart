import 'package:backend/model/model.dart' show Item, Purchase, Game, DLC, Store, PurchaseType;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository, DLCRepository, PurchaseRepository, StoreRepository;

import 'item_relation_manager.dart';


class PurchaseRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<Purchase, W> {
  PurchaseRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    this.dlcRepository = collectionRepository.dlcRepository,
    this.purchaseRepository = collectionRepository.purchaseRepository,
    this.storeRepository = collectionRepository.storeRepository,
    super(itemId: itemId);

  final GameRepository gameRepository;
  final DLCRepository dlcRepository;
  final PurchaseRepository purchaseRepository;
  final StoreRepository storeRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return gameRepository.relateGamePurchase(otherId, itemId);
      case DLC:
        return dlcRepository.relateDLCPurchase(otherId, itemId);
      case Store:
        return storeRepository.relateStorePurchase(otherId, itemId);
      case PurchaseType:
        return purchaseRepository.relatePurchaseType(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return gameRepository.unrelateGamePurchase(otherId, itemId);
      case DLC:
        return dlcRepository.unrelateDLCPurchase(otherId, itemId);
      case Store:
        return storeRepository.unrelateStorePurchase(itemId);
      case PurchaseType:
        return purchaseRepository.unrelatePurchaseType(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}