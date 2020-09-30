import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class StoreRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Store, W> {

  StoreRelationBloc({
    @required int storeID,
    @required StoreBloc itemBloc,
  }) : super(itemID: storeID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        return collectionRepository.getPurchasesFromStore(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}