import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class TypeRelationBloc<W extends CollectionItem> extends ItemRelationBloc<PurchaseType, W> {

  TypeRelationBloc({
    @required int typeID,
    @required TypeBloc itemBloc,
  }) : super(itemID: typeID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        return collectionRepository.getPurchasesFromType(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<PurchaseType, W> event) {

    int typeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.insertPurchaseType(otherID, typeID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<PurchaseType, W> event) {

    int typeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.deletePurchaseType(otherID, typeID);
    }

    return super.deleteRelationFuture(event);

  }

}