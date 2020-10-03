import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_relation.dart';


class TypeRelationBloc<W extends CollectionItem> extends ItemRelationBloc<PurchaseType, W> {

  TypeRelationBloc({
    @required int typeID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: typeID, collectionRepository: collectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        return collectionRepository.getPurchasesFromType(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.insertPurchaseType(otherID, itemID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.deletePurchaseType(otherID, itemID);
    }

    return super.deleteRelationFuture(event);

  }

}