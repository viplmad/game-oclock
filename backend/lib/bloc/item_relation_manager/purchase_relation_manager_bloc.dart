import 'package:backend/entity/entity.dart' show DLCEntity, GameEntity, PurchaseID, PurchaseTypeEntity, StoreEntity;
import 'package:backend/model/model.dart' show Item, Purchase, Game, DLC, Store, PurchaseType;
import 'package:backend/mapper/mapper.dart' show DLCMapper, GameMapper, PurchaseTypeMapper, StoreMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository, DLCRepository, PurchaseRepository, StoreRepository;

import 'item_relation_manager.dart';


class PurchaseRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<Purchase, PurchaseID, W> {
  PurchaseRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    this.dlcRepository = collectionRepository.dlcRepository,
    this.purchaseRepository = collectionRepository.purchaseRepository,
    this.storeRepository = collectionRepository.storeRepository,
    super(id: PurchaseID(itemId));

  final GameRepository gameRepository;
  final DLCRepository dlcRepository;
  final PurchaseRepository purchaseRepository;
  final StoreRepository storeRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Game:
        final GameEntity otherEntity = GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.relateGamePurchase(otherEntity.createId(), id);
      case DLC:
        final DLCEntity otherEntity = DLCMapper.modelToEntity(otherItem as DLC);
        return dlcRepository.relateDLCPurchase(otherEntity.createId(), id);
      case Store:
        final StoreEntity otherEntity = StoreMapper.modelToEntity(otherItem as Store);
        return storeRepository.relateStorePurchase(otherEntity.createId(), id);
      case PurchaseType:
        final PurchaseTypeEntity otherEntity = PurchaseTypeMapper.modelToEntity(otherItem as PurchaseType);
        return purchaseRepository.relatePurchaseType(id, otherEntity.createId());
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Game:
        final GameEntity otherEntity = GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.unrelateGamePurchase(otherEntity.createId(), id);
      case DLC:
        final DLCEntity otherEntity = DLCMapper.modelToEntity(otherItem as DLC);
        return dlcRepository.unrelateDLCPurchase(otherEntity.createId(), id);
      case Store:
        return storeRepository.unrelateStorePurchase(id);
      case PurchaseType:
        final PurchaseTypeEntity otherEntity = PurchaseTypeMapper.modelToEntity(otherItem as PurchaseType);
        return purchaseRepository.unrelatePurchaseType(id, otherEntity.createId());
    }

    return super.deleteRelationFuture(event);

  }
}