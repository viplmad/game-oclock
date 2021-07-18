import 'package:backend/model/model.dart' show Item, System, Platform;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_relation_manager.dart';


class SystemRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<System, W> {
  SystemRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.platformRepository = collectionRepository.platformRepository,
    super(itemId: itemId);

  final PlatformRepository platformRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Platform:
        return platformRepository.relatePlatformSystem(otherId, itemId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Platform:
        return platformRepository.unrelatePlatformSystem(otherId, itemId);
    }

    return super.deleteRelationFuture(event);

  }
}