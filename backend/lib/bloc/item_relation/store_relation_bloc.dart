import 'dart:async';

import 'package:backend/model/model.dart' show Item, Store, Purchase;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class StoreRelationBloc<W extends Item> extends ItemRelationBloc<Store, W> {
  StoreRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required StoreRelationManagerBloc<W> managerBloc,
  }) :
    this.purchaseRepository = collectionRepository.purchaseRepository,
    super(itemId: itemId, managerBloc: managerBloc);

  final PurchaseRepository purchaseRepository;

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        return purchaseRepository.findAllPurchasesFromStore(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}