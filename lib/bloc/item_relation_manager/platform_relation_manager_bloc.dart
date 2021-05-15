import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class PlatformRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Platform, W> {
  PlatformRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.relateGamePlatform(otherId, itemId);
      case System:
        return iCollectionRepository.relatePlatformSystem(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.unrelateGamePlatform(otherId, itemId);
      case System:
        return iCollectionRepository.unrelatePlatformSystem(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}