import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation.dart';


class StoreRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Store, W> {

  StoreRelationBloc({
    @required int storeID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: storeID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        return iCollectionRepository.getPurchasesFromStore(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return iCollectionRepository.insertStorePurchase(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return iCollectionRepository.deleteStorePurchase(otherID);
    }

    return super.deleteRelationFuture(event);

  }

}