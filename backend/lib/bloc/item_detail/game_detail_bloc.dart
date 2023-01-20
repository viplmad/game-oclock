import 'package:game_collection_client/api.dart' show GameDTO, NewGameDTO;

import 'package:backend/service/service.dart'
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
  Future<GameDTO> get() async {
    final GameDTO game = await super.get();
    final DateTime? firstFinish =
        await gameFinishService.getFirstFinish(itemId);
    final Duration totalTime = await gameLogService.getTotalPlayedTime(itemId);

    game.firstFinish = firstFinish;
    game.totalTime = totalTime;

    return game;
  }
}
