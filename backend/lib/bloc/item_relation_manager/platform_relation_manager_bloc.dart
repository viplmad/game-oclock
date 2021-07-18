import 'package:backend/model/model.dart' show Item, Platform, Game, System;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository, PlatformRepository;

import 'item_relation_manager.dart';


class PlatformRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<Platform, W> {
  PlatformRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    this.platformRepository = collectionRepository.platformRepository,
    super(itemId: itemId);

  final GameRepository gameRepository;
  final PlatformRepository platformRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return gameRepository.relateGamePlatform(otherId, itemId);
      case System:
        return platformRepository.relatePlatformSystem(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return gameRepository.unrelateGamePlatform(otherId, itemId);
      case System:
        return platformRepository.unrelatePlatformSystem(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}