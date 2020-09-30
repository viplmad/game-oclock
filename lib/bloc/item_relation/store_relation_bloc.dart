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

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<Store, W> event) {

    int storeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.insertStorePurchase(storeID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<Store, W> event) {

    int storeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.deleteStorePurchase(otherID);
    }

    return super.deleteRelationFuture(event);

  }

}