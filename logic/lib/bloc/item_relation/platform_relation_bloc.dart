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
  })  : _dlcService = collectionService.dlcService,
        super();

  final DLCService _dlcService;

  @override
  Future<List<DLCAvailableDTO>> getRelationItems() {
    return _dlcService.getPlatformAvailableDLCs(itemId);
  }
}

class PlatformGameRelationBloc extends ItemRelationBloc<GameAvailableDTO> {
  PlatformGameRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : _gameService = collectionService.gameService,
        super();

  final GameService _gameService;

  @override
  Future<List<GameAvailableDTO>> getRelationItems() {
    return _gameService.getPlatformAvailableGames(itemId);
  }
}