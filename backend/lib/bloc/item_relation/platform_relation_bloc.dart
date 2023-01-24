import 'package:game_collection_client/api.dart'
    show GameAvailableDTO, DLCAvailableDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameService, DLCService;

import 'item_relation.dart';

class PlatformDLCRelationBloc extends ItemRelationBloc<DLCAvailableDTO> {
  PlatformDLCRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : dlcService = collectionService.dlcService,
        super();

  final DLCService dlcService;

  @override
  Future<List<DLCAvailableDTO>> getRelationItems() {
    return dlcService.getPlatformAvailableDLCs(itemId);
  }
}

class PlatformGameRelationBloc extends ItemRelationBloc<GameAvailableDTO> {
  PlatformGameRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : gameService = collectionService.gameService,
        super();

  final GameService gameService;

  @override
  Future<List<GameAvailableDTO>> getRelationItems() {
    return gameService.getPlatformAvailableGames(itemId);
  }
}
