import 'package:game_collection_client/api.dart'
    show GameAvailableDTO, DLCAvailableDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameService, DLCService;

import 'item_relation_manager.dart';

class PlatformDLCRelationManagerBloc
    extends ItemRelationManagerBloc<DLCAvailableDTO> {
  PlatformDLCRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : dlcService = collectionService.dlcService,
        super();

  final DLCService dlcService;

  @override
  Future<void> addRelation(AddItemRelation<DLCAvailableDTO> event) {
    return dlcService.addAvailability(
      event.otherItem.id,
      itemId,
      event.otherItem.availableDate,
    );
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<DLCAvailableDTO> event) {
    return dlcService.removeAvailability(event.otherItem.id, itemId);
  }
}

class PlatformGameRelationManagerBloc
    extends ItemRelationManagerBloc<GameAvailableDTO> {
  PlatformGameRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : gameService = collectionService.gameService,
        super();

  final GameService gameService;

  @override
  Future<void> addRelation(AddItemRelation<GameAvailableDTO> event) {
    return gameService.addAvailability(
      event.otherItem.id,
      itemId,
      event.otherItem.availableDate,
    );
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<GameAvailableDTO> event) {
    return gameService.removeAvailability(event.otherItem.id, itemId);
  }
}
