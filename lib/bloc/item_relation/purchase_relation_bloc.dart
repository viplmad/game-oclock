import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class PurchaseRelationBloc extends ItemRelationBloc {

  PurchaseRelationBloc({
    @required int purchaseID,
    @required Type relationType,
    @required ItemBloc itemBloc,
  }) : super(itemID: purchaseID, relationType: relationType, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationType) {
      case Game:
        return collectionRepository.getGamesFromPurchase(itemID);
      case DLC:
        return collectionRepository.getDLCsFromPurchase(itemID);
      case Store:
        return collectionRepository.getStoreFromPurchase(itemID).map( (CollectionItem store) => store != null? [store] : [] );
      case PurchaseType:
        return collectionRepository.getTypesFromPurchase(itemID);
    }

    return super.getRelationStream();

  }

}