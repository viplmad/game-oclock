import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class GameRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Game, W> {

  GameRelationManagerBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case DLC:
        return iCollectionRepository.insertGameDLC(itemID, otherID);
      case Purchase:
        return iCollectionRepository.insertGamePurchase(itemID, otherID);
      case Platform:
        return iCollectionRepository.insertGamePlatform(itemID, otherID);
      case Tag:
        return iCollectionRepository.insertGameTag(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case DLC:
        return iCollectionRepository.deleteGameDLC(otherID);
      case Purchase:
        return iCollectionRepository.deleteGamePurchase(itemID, otherID);
      case Platform:
        return iCollectionRepository.deleteGamePlatform(itemID, otherID);
      case Tag:
        return iCollectionRepository.deleteGameTag(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}