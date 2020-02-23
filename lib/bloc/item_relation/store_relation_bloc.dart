import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class StoreRelationBloc extends ItemRelationBloc {

  StoreRelationBloc({
    @required int storeID,
    @required Type relationType,
    @required ItemBloc itemBloc,
  }) : super(itemID: storeID, relationType: relationType, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationType) {
      case Purchase:
        return collectionRepository.getPurchasesFromStore(itemID);
    }

    return super.getRelationStream();

  }

}