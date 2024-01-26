import 'package:game_oclock_client/api.dart'
    show DLCDTO, GameLogDTO, NewGameLogDTO, PlatformAvailableDTO, TagDTO;

import 'package:logic/model/model.dart' show ItemFinish;
import 'package:logic/service/service.dart'
    show
        DLCService,
        GameFinishService,
        GameLogService,
        GameOClockService,
        PlatformService,
        TagService;

import 'item_relation.dart';

class GameFinishRelationBloc extends ItemRelationBloc<ItemFinish, DateTime> {
  GameFinishRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _gameFinishService = collectionService.gameFinishService,
        super();

  final GameFinishService _gameFinishService;

  @override
  Future<List<ItemFinish>> getRelationItems() {
    return _gameFinishService
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

class GamePlayTimeRelationBloc
    extends ItemRelationBloc<GameLogDTO, NewGameLogDTO> {
  GamePlayTimeRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _gameLogsService = collectionService.gameLogService,
        super();

  final GameLogService _gameLogsService;

  @override
  Future<List<GameLogDTO>> getRelationItems() {
    return _gameLogsService
        .getTotalPlayedTime(itemId)
        .asStream()
        .map(
          (Duration time) => <GameLogDTO>[
            GameLogDTO(
              startDatetime: DateTime.now(),
              endDatetime: DateTime.now(),
              // Only need time
              time: time,
            ),
          ],
        )
        .first;
  }
}

class GameDLCRelationBloc extends ItemRelationBloc<DLCDTO, DLCDTO> {
  GameDLCRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _dlcService = collectionService.dlcService,
        super();

  final DLCService _dlcService;

  @override
  Future<List<DLCDTO>> getRelationItems() {
    return _dlcService.getGameDLCs(itemId);
  }
}

class GamePlatformRelationBloc
    extends ItemRelationBloc<PlatformAvailableDTO, PlatformAvailableDTO> {
  GamePlatformRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _platformService = collectionService.platformService,
        super();

  final PlatformService _platformService;

  @override
  Future<List<PlatformAvailableDTO>> getRelationItems() {
    return _platformService.getGameAvailablePlatforms(itemId);
  }
}

class GameTagRelationBloc extends ItemRelationBloc<TagDTO, TagDTO> {
  GameTagRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _tagService = collectionService.tagService,
        super();

  final TagService _tagService;

  @override
  Future<List<TagDTO>> getRelationItems() {
    return _tagService.getGameTags(itemId);
  }
}
