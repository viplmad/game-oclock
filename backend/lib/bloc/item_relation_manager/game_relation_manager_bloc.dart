import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class GameRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Game, W> {
  GameRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case DLC:
        return iCollectionRepository.relateGameDLC(itemId, otherId);
      case Purchase:
        return iCollectionRepository.relateGamePurchase(itemId, otherId);
      case Platform:
        return iCollectionRepository.relateGamePlatform(itemId, otherId);
      case Tag:
        return iCollectionRepository.relateGameTag(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case DLC:
        return iCollectionRepository.unrelateGameDLC(otherId);
      case Purchase:
        return iCollectionRepository.unrelateGamePurchase(itemId, otherId);
      case Platform:
        return iCollectionRepository.unrelateGamePlatform(itemId, otherId);
      case Tag:
        return iCollectionRepository.unrelateGameTag(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}

class GameTimeLogRelationManagerBloc extends RelationManagerBloc<Game, GameTimeLog> {
  GameTimeLogRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
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
    required ICollectionRepository iCollectionRepository,
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