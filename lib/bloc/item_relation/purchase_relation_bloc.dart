import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class PurchaseRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Purchase, W> {

  PurchaseRelationBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
    @required PurchaseRelationManagerBloc<W> managerBloc,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

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

}