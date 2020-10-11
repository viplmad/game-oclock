import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class DLCRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<DLC, W> {

  DLCRelationManagerBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.relateGameDLC(otherID, itemID);
      case Purchase:
        return iCollectionRepository.relateDLCPurchase(itemID, otherID);
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