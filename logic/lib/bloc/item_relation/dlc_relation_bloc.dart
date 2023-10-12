import 'package:game_collection_client/api.dart'
    show GameDTO, PlatformAvailableDTO;

import 'package:logic/model/model.dart' show ItemFinish;
import 'package:logic/service/service.dart'
    show GameOClockService, GameService, DLCFinishService, PlatformService;

import 'item_relation.dart';

class DLCFinishRelationBloc extends ItemRelationBloc<ItemFinish, DateTime> {
  DLCFinishRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _dlcFinishService = collectionService.dlcFinishService,
        super();

  final DLCFinishService _dlcFinishService;

  @override
  Future<List<ItemFinish>> getRelationItems() {
    return _dlcFinishService
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

class DLCGameRelationBloc extends ItemRelationBloc<GameDTO, GameDTO> {
  DLCGameRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _gameService = collectionService.gameService,
        super();

  final GameService _gameService;

  @override
  Future<List<GameDTO>> getRelationItems() {
    return _gameService.getDLCBasegameAsList(itemId);
  }
}

class DLCPlatformRelationBloc
    extends ItemRelationBloc<PlatformAvailableDTO, PlatformAvailableDTO> {
  DLCPlatformRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _platformService = collectionService.platformService,
        super();

  final PlatformService _platformService;

  @override
  Future<List<PlatformAvailableDTO>> getRelationItems() {
    return _platformService.getDLCAvailablePlatforms(itemId);
  }
}
