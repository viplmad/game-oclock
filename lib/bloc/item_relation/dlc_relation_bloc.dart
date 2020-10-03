import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_relation.dart';


class DLCRelationBloc<W extends CollectionItem> extends ItemRelationBloc<DLC, W> {

  DLCRelationBloc({
    @required int dlcID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: dlcID, collectionRepository: collectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return collectionRepository.getBaseGameFromDLC(itemID).map<List<Game>>( (Game game) => game != null? [game] : [] ) as Stream<List<W>>;
      case Purchase:
        return collectionRepository.getPurchasesFromDLC(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGameDLC(otherID, itemID);
      case Purchase:
        return collectionRepository.insertDLCPurchase(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGameDLC(itemID);
      case Purchase:
        return collectionRepository.deleteDLCPurchase(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}