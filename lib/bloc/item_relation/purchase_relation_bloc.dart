import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class PurchaseRelationBloc extends ItemRelationBloc {

  PurchaseRelationBloc({
    @required int purchaseID,
    @required String relationField,
    @required ItemBloc itemBloc,
  }) : super(itemID: purchaseID, relationField: relationField, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationField) {
      case gameTable:
        return collectionRepository.getGamesFromPurchase(itemID);
      case dlcTable:
        return collectionRepository.getDLCsFromPurchase(itemID);
      case storeTable:
        return collectionRepository.getStoreFromPurchase(itemID).map( (CollectionItem store) => store != null? [store] : [] );
      case typeTable:
        return collectionRepository.getTypesFromPurchase(itemID);
    }

    return super.getRelationStream();

  }

}