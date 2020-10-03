import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation.dart';


class TypeRelationBloc<W extends CollectionItem> extends ItemRelationBloc<PurchaseType, W> {

  TypeRelationBloc({
    @required int typeID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: typeID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        return iCollectionRepository.getPurchasesFromType(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return iCollectionRepository.insertPurchaseType(otherID, itemID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return iCollectionRepository.deletePurchaseType(otherID, itemID);
    }

    return super.deleteRelationFuture(event);

  }

}