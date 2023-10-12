import 'package:game_collection_client/api.dart'
    show GameAvailableDTO, DLCAvailableDTO;

import 'package:logic/service/service.dart'
    show GameOClockService, GameService, DLCService;

import 'item_relation_manager.dart';

class PlatformDLCRelationManagerBloc
    extends ItemRelationManagerBloc<DLCAvailableDTO, DLCAvailableDTO> {
  PlatformDLCRelationManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  })  : _dlcService = collectionService.dlcService,
        super();

  final DLCService _dlcService;

  @override
  Future<void> addRelation(AddItemRelation<DLCAvailableDTO> event) {
    return _dlcService.addAvailability(
      event.otherItem.id,
      itemId,
      event.otherItem.availableDate,
    );
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<DLCAvailableDTO> event) {
    return _dlcService.removeAvailability(event.otherItem.id, itemId);
  }
}

class PlatformGameRelationManagerBloc
    extends ItemRelationManagerBloc<GameAvailableDTO, GameAvailableDTO> {
  PlatformGameRelationManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  })  : _gameService = collectionService.gameService,
        super();

  final GameService _gameService;

  @override
  Future<void> addRelation(AddItemRelation<GameAvailableDTO> event) {
    return _gameService.addAvailability(
      event.otherItem.id,
      itemId,
      event.otherItem.availableDate,
    );
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<GameAvailableDTO> event) {
    return _gameService.removeAvailability(event.otherItem.id, itemId);
  }
}
