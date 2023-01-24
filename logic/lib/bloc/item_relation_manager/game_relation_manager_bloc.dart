import 'package:game_collection_client/api.dart'
    show GameLogDTO, DLCDTO, PlatformAvailableDTO, TagDTO;

import 'package:logic/model/model.dart' show ItemFinish;
import 'package:logic/service/service.dart'
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
  })  : _gameFinishService = collectionService.gameFinishService,
        super();

  final GameFinishService _gameFinishService;

  @override
  Future<void> addRelation(AddItemRelation<ItemFinish> event) {
    return _gameFinishService.create(itemId, event.otherItem.date);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<ItemFinish> event) {
    return _gameFinishService.delete(itemId, event.otherItem.date);
  }
}

class GameLogRelationManagerBloc extends ItemRelationManagerBloc<GameLogDTO> {
  GameLogRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : _gameLogService = collectionService.gameLogService,
        super();

  final GameLogService _gameLogService;

  @override
  Future<void> addRelation(AddItemRelation<GameLogDTO> event) {
    return _gameLogService.create(itemId, event.otherItem);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<GameLogDTO> event) {
    return _gameLogService.delete(itemId, event.otherItem.datetime);
  }
}

class GameDLCRelationManagerBloc extends ItemRelationManagerBloc<DLCDTO> {
  GameDLCRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : _dlcService = collectionService.dlcService,
        super();

  final DLCService _dlcService;

  @override
  Future<void> addRelation(AddItemRelation<DLCDTO> event) {
    return _dlcService.setBasegame(event.otherItem.id, itemId);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<DLCDTO> event) {
    return _dlcService.clearBasegame(event.otherItem.id);
  }
}

class GamePlatformRelationManagerBloc
    extends ItemRelationManagerBloc<PlatformAvailableDTO> {
  GamePlatformRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : _gameService = collectionService.gameService,
        super();

  final GameService _gameService;

  @override
  Future<void> addRelation(AddItemRelation<PlatformAvailableDTO> event) {
    return _gameService.addAvailability(
      itemId,
      event.otherItem.id,
      event.otherItem.availableDate,
    );
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<PlatformAvailableDTO> event) {
    return _gameService.removeAvailability(itemId, event.otherItem.id);
  }
}

class GameTagRelationManagerBloc extends ItemRelationManagerBloc<TagDTO> {
  GameTagRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : _gameService = collectionService.gameService,
        super();

  final GameService _gameService;

  @override
  Future<void> addRelation(AddItemRelation<TagDTO> event) {
    return _gameService.tag(itemId, event.otherItem.id);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<TagDTO> event) {
    return _gameService.untag(itemId, event.otherItem.id);
  }
}
