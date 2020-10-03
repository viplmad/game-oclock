import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation.dart';


class DLCRelationBloc<W extends CollectionItem> extends ItemRelationBloc<DLC, W> {

  DLCRelationBloc({
    @required int dlcID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: dlcID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.getBaseGameFromDLC(itemID).map<List<Game>>( (Game game) => game != null? [game] : [] ) as Stream<List<W>>;
      case Purchase:
        return iCollectionRepository.getPurchasesFromDLC(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.insertGameDLC(otherID, itemID);
      case Purchase:
        return iCollectionRepository.insertDLCPurchase(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.deleteGameDLC(itemID);
      case Purchase:
        return iCollectionRepository.deleteDLCPurchase(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}