import 'package:game_collection_client/api.dart' show GameDTO, NewGameDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameFinishService, GameLogService, GameService;

import 'item_detail.dart';

class GameDetailBloc extends ItemDetailBloc<GameDTO, NewGameDTO, GameService> {
  GameDetailBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : gameFinishService = collectionService.gameFinishService,
        gameLogService = collectionService.gameLogService,
        super(
          service: collectionService.gameService,
        );

  final GameFinishService gameFinishService;
  final GameLogService gameLogService;

  @override
  Future<GameDTO> getAdditionalFields(GameDTO item) async {
    final DateTime? firstFinish =
        await gameFinishService.getFirstFinish(itemId);
    final Duration totalTime = await gameLogService.getTotalPlayedTime(itemId);

    return _populateGame(item, firstFinish, totalTime);
  }

  @override
  GameDTO addAdditionalFields(GameDTO item, GameDTO previousItem) {
    return _populateGame(
      item,
      previousItem.firstFinish,
      previousItem.totalTime,
    );
  }

  GameDTO _populateGame(
    GameDTO item,
    DateTime? firstFinish,
    Duration? totalTime,
  ) {
    item.firstFinish = firstFinish;
    item.totalTime = totalTime;

    return item;
  }
}
