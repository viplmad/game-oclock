import 'package:backend/entity/entity.dart'
    show GameEntity, PlatformID, SystemEntity;
import 'package:backend/model/model.dart' show Item, Platform, Game, System;
import 'package:backend/mapper/mapper.dart' show GameMapper, SystemMapper;
import 'package:backend/repository/repository.dart'
    show GameRepository, PlatformRepository;

import 'item_relation_manager.dart';

class PlatformRelationManagerBloc<W extends Item>
    extends ItemRelationManagerBloc<Platform, PlatformID, W> {
  PlatformRelationManagerBloc({
    required int itemId,
    required super.collectionRepository,
  })  : gameRepository = collectionRepository.gameRepository,
        platformRepository = collectionRepository.platformRepository,
        super(id: PlatformID(itemId));

  final GameRepository gameRepository;
  final PlatformRepository platformRepository;

  @override
  Future<Object?> addRelation(AddItemRelation<W> event) {
    final W otherItem = event.otherItem;

    switch (W) {
      case Game:
        final GameEntity otherEntity =
            GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.relateGamePlatform(otherEntity.createId(), id);
      case System:
        final SystemEntity otherEntity =
            SystemMapper.modelToEntity(otherItem as System);
        return platformRepository.relatePlatformSystem(
          id,
          otherEntity.createId(),
        );
    }

    return super.addRelation(event);
  }

  @override
  Future<Object?> deleteRelation(DeleteItemRelation<W> event) {
    final W otherItem = event.otherItem;

    switch (W) {
      case Game:
        final GameEntity otherEntity =
            GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.unrelateGamePlatform(otherEntity.createId(), id);
      case System:
        final SystemEntity otherEntity =
            SystemMapper.modelToEntity(otherItem as System);
        return platformRepository.unrelatePlatformSystem(
          id,
          otherEntity.createId(),
        );
    }

    return super.deleteRelation(event);
  }
}
