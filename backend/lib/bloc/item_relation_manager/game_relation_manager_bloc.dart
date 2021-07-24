import 'package:backend/entity/entity.dart' show DLCEntity, GameFinishEntity, GameID, GameTagEntity, GameTimeLogEntity, PlatformEntity, PurchaseEntity;
import 'package:backend/model/model.dart' show DLC, Game, GameFinish, GameTimeLog, Item, Platform, Purchase, Tag;
import 'package:backend/mapper/mapper.dart' show DLCMapper, GameFinishMapper, GameTagMapper, GameTimeLogMapper, PlatformMapper, PurchaseMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameFinishRepository, GameRepository, GameTimeLogRepository;

import 'item_relation_manager.dart';


class GameRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<Game, GameID, W> {
  GameRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    this.gameFinishRepository = collectionRepository.gameFinishRepository,
    this.gameTimeLogRepository = collectionRepository.gameTimeLogRepository,
    super(id: GameID(itemId));

  final GameRepository gameRepository;
  final GameFinishRepository gameFinishRepository;
  final GameTimeLogRepository gameTimeLogRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case GameFinish:
        final GameFinishEntity otherEntity = GameFinishMapper.modelToEntity(id.id, otherItem as GameFinish);
        return gameFinishRepository.create(otherEntity);
      case GameTimeLog:
        final GameTimeLogEntity otherEntity = GameTimeLogMapper.modelToEntity(id.id, otherItem as GameTimeLog);
        return gameTimeLogRepository.create(otherEntity);
      case DLC:
        final DLCEntity otherEntity = DLCMapper.modelToEntity(otherItem as DLC);
        return gameRepository.relateGameDLC(id, otherEntity.createId());
      case Platform:
        final PlatformEntity otherEntity = PlatformMapper.modelToEntity(otherItem as Platform);
        return gameRepository.relateGamePlatform(id, otherEntity.createId());
      case Purchase:
        final PurchaseEntity otherEntity = PurchaseMapper.modelToEntity(otherItem as Purchase);
        return gameRepository.relateGamePurchase(id, otherEntity.createId());
      case Tag:
        final GameTagEntity otherEntity = GameTagMapper.modelToEntity(otherItem as Tag);
        return gameRepository.relateGameTag(id, otherEntity.createId());
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case GameFinish:
        final GameFinishEntity otherEntity = GameFinishMapper.modelToEntity(id.id, otherItem as GameFinish);
        return gameFinishRepository.deleteById(otherEntity.createId());
      case GameTimeLog:
        final GameTimeLogEntity otherEntity = GameTimeLogMapper.modelToEntity(id.id, otherItem as GameTimeLog);
        return gameTimeLogRepository.deleteById(otherEntity.createId());
      case DLC:
        final DLCEntity otherEntity = DLCMapper.modelToEntity(otherItem as DLC);
        return gameRepository.unrelateGameDLC(otherEntity.createId());
      case Purchase:
        final PurchaseEntity otherEntity = PurchaseMapper.modelToEntity(otherItem as Purchase);
        return gameRepository.unrelateGamePurchase(id, otherEntity.createId());
      case Platform:
        final PlatformEntity otherEntity = PlatformMapper.modelToEntity(otherItem as Platform);
        return gameRepository.unrelateGamePlatform(id, otherEntity.createId());
      case Tag:
        final GameTagEntity otherEntity = GameTagMapper.modelToEntity(otherItem as Tag);
        return gameRepository.unrelateGameTag(id, otherEntity.createId());
    }

    return super.deleteRelationFuture(event);

  }
}