import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class SystemRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<System, W> {
  SystemRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Platform:
        return iCollectionRepository.relatePlatformSystem(otherId, itemId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Platform:
        return iCollectionRepository.deletePlatformSystem(otherId, itemId);
    }

    return super.deleteRelationFuture(event);

  }
}