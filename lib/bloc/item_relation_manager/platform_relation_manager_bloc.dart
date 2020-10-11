import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class PlatformRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Platform, W> {

  PlatformRelationManagerBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.relateGamePlatform(otherID, itemID);
      case System:
        return iCollectionRepository.relatePlatformSystem(itemID, otherID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return iCollectionRepository.deleteGamePlatform(otherID, itemID);
      case System:
        return iCollectionRepository.deletePlatformSystem(itemID, otherID);
    }

    return super.deleteRelationFuture(event);

  }

}