import 'package:game_collection_client/api.dart' show GameDTO, NewGameDTO;

import 'package:backend/model/model.dart' show GameDetailed;
import 'package:backend/service/service.dart'
    show GameCollectionService, GameFinishService, GameLogService, GameService;

import 'item_detail.dart';

class GameDetailBloc extends ItemDetailBloc<GameDTO, NewGameDTO, GameService> {
  GameDetailBloc({
    required int itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : gameFinishService = collectionService.gameFinishService,
        gameLogService = collectionService.gameLogService,
        super(
          itemId: itemId,
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

    return GameDetailed.withDTO(game, firstFinish, totalTime);
  }
}
