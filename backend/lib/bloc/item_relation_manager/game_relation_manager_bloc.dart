import 'package:backend/model/model.dart' show Item, Game, DLC, Platform, Purchase, Tag;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import 'item_relation_manager.dart';


class GameRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<Game, W> {
  GameRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    super(itemId: itemId);

  final GameRepository gameRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case DLC:
        return gameRepository.relateGameDLC(itemId, otherId);
      case Platform:
        return gameRepository.relateGamePlatform(itemId, otherId);
      case Purchase:
        return gameRepository.relateGamePurchase(itemId, otherId);
      case Tag:
        return gameRepository.relateGameTag(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case DLC:
        return gameRepository.unrelateGameDLC(otherId);
      case Purchase:
        return gameRepository.unrelateGamePurchase(itemId, otherId);
      case Platform:
        return gameRepository.unrelateGamePlatform(itemId, otherId);
      case Tag:
        return gameRepository.unrelateGameTag(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}

class GameTimeLogRelationManagerBloc extends RelationManagerBloc<Game, GameTimeLog> {
  GameTimeLogRelationManagerBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddRelation<GameTimeLog> event) {

    return iCollectionRepository.createGameTimeLog(itemId, event.otherItem);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteRelation<GameTimeLog> event) {

    return iCollectionRepository.deleteGameTimeLogById(itemId, event.otherItem.dateTime);

  }
}

class GameFinishRelationManagerBloc extends RelationManagerBloc<Game, GameFinish> {
  GameFinishRelationManagerBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddRelation<GameFinish> event) {

    return iCollectionRepository.createGameFinish(itemId, event.otherItem);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteRelation<GameFinish> event) {

    return iCollectionRepository.deleteGameFinishById(itemId, event.otherItem.dateTime);

  }
}