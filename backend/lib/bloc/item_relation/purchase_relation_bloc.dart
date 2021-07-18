import 'dart:async';

import 'package:backend/model/model.dart' show Item, Purchase, Game, DLC, Store, PurchaseType;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository, DLCRepository, PurchaseTypeRepository, StoreRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class PurchaseRelationBloc<W extends Item> extends ItemRelationBloc<Purchase, W> {
  PurchaseRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required PurchaseRelationManagerBloc<W> managerBloc,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    this.dlcRepository = collectionRepository.dlcRepository,
    this.storeRepository = collectionRepository.storeRepository,
    this.purchaseTypeRepository = collectionRepository.purchaseTypeRepository,
    super(itemId: itemId, managerBloc: managerBloc);

  final GameRepository gameRepository;
  final DLCRepository dlcRepository;
  final StoreRepository storeRepository;
  final PurchaseTypeRepository purchaseTypeRepository;

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return gameRepository.findAllGamesFromPurchase(itemId) as Stream<List<W>>;
      case DLC:
        return dlcRepository.findAllDLCsFromPurchase(itemId) as Stream<List<W>>;
      case Store:
        return storeRepository.findStoreFromPurchase(itemId).map<List<Store>>( (Store? store) => store != null? <Store>[store] : <Store>[] ) as Stream<List<W>>;
      case PurchaseType:
        return purchaseTypeRepository.findAllPurchaseTypesFromPurchase(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}