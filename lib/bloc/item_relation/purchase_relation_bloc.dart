import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class PurchaseRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Purchase, W> {

  PurchaseRelationBloc({
    @required int purchaseID,
    @required PurchaseBloc itemBloc,
  }) : super(itemID: purchaseID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return collectionRepository.getGamesFromPurchase(itemID) as Stream<List<W>>;
      case DLC:
        return collectionRepository.getDLCsFromPurchase(itemID) as Stream<List<W>>;
      case Store:
        return collectionRepository.getStoreFromPurchase(itemID).map<List<Store>>( (Store store) => store != null? [store] : [] ) as Stream<List<W>>;
      case PurchaseType:
        return collectionRepository.getTypesFromPurchase(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}