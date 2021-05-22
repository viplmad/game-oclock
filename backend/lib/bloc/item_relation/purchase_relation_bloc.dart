import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class PurchaseRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Purchase, W> {
  PurchaseRelationBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required PurchaseRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.findAllGamesFromPurchase(itemId) as Stream<List<W>>;
      case DLC:
        return iCollectionRepository.findAllDLCsFromPurchase(itemId) as Stream<List<W>>;
      case Store:
        return iCollectionRepository.findStoreFromPurchase(itemId).map<List<Store>>( (Store? store) => store != null? <Store>[store] : <Store>[] ) as Stream<List<W>>;
      case PurchaseType:
        return iCollectionRepository.findAllPurchaseTypesFromPurchase(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}