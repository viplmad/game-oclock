import 'package:game_collection_client/api.dart'
    show GameDTO, PlatformAvailableDTO;

import 'package:logic/model/model.dart' show ItemFinish;
import 'package:logic/service/service.dart'
    show GameCollectionService, GameService, DLCFinishService, PlatformService;

import 'item_relation.dart';

class DLCFinishRelationBloc extends ItemRelationBloc<ItemFinish> {
  DLCFinishRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : dlcFinishService = collectionService.dlcFinishService,
        super();

  final DLCFinishService dlcFinishService;

  @override
  Future<List<ItemFinish>> getRelationItems() {
    return dlcFinishService
        .getAll(itemId)
        .asStream()
        .map(
          (List<DateTime> dates) => dates
              .map((DateTime date) => ItemFinish(date))
              .toList(growable: false),
        )
        .first;
  }
}

class DLCGameRelationBloc extends ItemRelationBloc<GameDTO> {
  DLCGameRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : gameService = collectionService.gameService,
        super();

  final GameService gameService;

  @override
  Future<List<GameDTO>> getRelationItems() {
    return gameService.getDLCBasegameAsList(itemId);
  }
}

class DLCPlatformRelationBloc extends ItemRelationBloc<PlatformAvailableDTO> {
  DLCPlatformRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : platformService = collectionService.platformService,
        super();

  final PlatformService platformService;

  @override
  Future<List<PlatformAvailableDTO>> getRelationItems() {
    return platformService.getDLCAvailablePlatforms(itemId);
  }
}
