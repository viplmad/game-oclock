import 'package:game_collection_client/api.dart'
    show DLCDTO, PlatformAvailableDTO, TagDTO;

import 'package:logic/model/model.dart' show ItemFinish;
import 'package:logic/service/service.dart'
    show
        GameCollectionService,
        GameFinishService,
        DLCService,
        PlatformService,
        TagService;

import 'item_relation.dart';

class GameFinishRelationBloc extends ItemRelationBloc<ItemFinish> {
  GameFinishRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : gameFinishService = collectionService.gameFinishService,
        super();

  final GameFinishService gameFinishService;

  @override
  Future<List<ItemFinish>> getRelationItems() {
    return gameFinishService
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

class GameDLCRelationBloc extends ItemRelationBloc<DLCDTO> {
  GameDLCRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : dlcService = collectionService.dlcService,
        super();

  final DLCService dlcService;

  @override
  Future<List<DLCDTO>> getRelationItems() {
    return dlcService.getGameDLCs(itemId);
  }
}

class GamePlatformRelationBloc extends ItemRelationBloc<PlatformAvailableDTO> {
  GamePlatformRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : platformService = collectionService.platformService,
        super();

  final PlatformService platformService;

  @override
  Future<List<PlatformAvailableDTO>> getRelationItems() {
    return platformService.getGameAvailablePlatforms(itemId);
  }
}

class GameTagRelationBloc extends ItemRelationBloc<TagDTO> {
  GameTagRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : tagService = collectionService.tagService,
        super();

  final TagService tagService;

  @override
  Future<List<TagDTO>> getRelationItems() {
    return tagService.getGameTags(itemId);
  }
}
