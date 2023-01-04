import 'package:game_collection_client/api.dart'
    show GameLogDTO, DLCDTO, PlatformAvailableDTO, TagDTO;

import 'package:backend/model/model.dart' show ItemFinish;
import 'package:backend/service/service.dart'
    show
        GameCollectionService,
        GameService,
        GameFinishService,
        GameLogService,
        DLCService;

import 'item_relation_manager.dart';

class GameFinishRelationManagerBloc
    extends ItemRelationManagerBloc<ItemFinish> {
  GameFinishRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : gameFinishService = collectionService.gameFinishService,
        super();

  final GameFinishService gameFinishService;

  @override
  Future<void> addRelation(AddItemRelation<ItemFinish> event) {
    return gameFinishService.create(itemId, event.otherItem.date);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<ItemFinish> event) {
    return gameFinishService.delete(itemId, event.otherItem.date);
  }
}

class GameLogRelationManagerBloc extends ItemRelationManagerBloc<GameLogDTO> {
  GameLogRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : gameLogService = collectionService.gameLogService,
        super();

  final GameLogService gameLogService;

  @override
  Future<void> addRelation(AddItemRelation<GameLogDTO> event) {
    return gameLogService.create(itemId, event.otherItem);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<GameLogDTO> event) {
    return gameLogService.delete(itemId, event.otherItem.datetime);
  }
}

class GameDLCRelationManagerBloc extends ItemRelationManagerBloc<DLCDTO> {
  GameDLCRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : dlcService = collectionService.dlcService,
        super();

  final DLCService dlcService;

  @override
  Future<void> addRelation(AddItemRelation<DLCDTO> event) {
    return dlcService.setBasegame(event.otherItem.id, itemId);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<DLCDTO> event) {
    return dlcService.clearBasegame(event.otherItem.id);
  }
}

class GamePlatformRelationManagerBloc
    extends ItemRelationManagerBloc<PlatformAvailableDTO> {
  GamePlatformRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : gameService = collectionService.gameService,
        super();

  final GameService gameService;

  @override
  Future<void> addRelation(AddItemRelation<PlatformAvailableDTO> event) {
    return gameService.addAvailability(
      itemId,
      event.otherItem.id,
      event.otherItem.availableDate,
    );
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<PlatformAvailableDTO> event) {
    return gameService.removeAvailability(itemId, event.otherItem.id);
  }
}

class GameTagRelationManagerBloc extends ItemRelationManagerBloc<TagDTO> {
  GameTagRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : gameService = collectionService.gameService,
        super();

  final GameService gameService;

  @override
  Future<void> addRelation(AddItemRelation<TagDTO> event) {
    return gameService.tag(itemId, event.otherItem.id);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<TagDTO> event) {
    return gameService.untag(itemId, event.otherItem.id);
  }
}
