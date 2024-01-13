import 'package:game_oclock_client/api.dart' show GameDTO, NewGameDTO;

import 'package:logic/service/service.dart'
    show GameOClockService, GameFinishService, GameLogService, GameService;

import 'item_detail.dart';

class GameDetailBloc extends ItemDetailBloc<GameDTO, NewGameDTO, GameService> {
  GameDetailBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _gameFinishService = collectionService.gameFinishService,
        _gameLogService = collectionService.gameLogService,
        super(
          service: collectionService.gameService,
        );

  final GameFinishService _gameFinishService;
  final GameLogService _gameLogService;

  @override
  Future<GameDTO> getAdditionalFields(GameDTO item) async {
    final DateTime? firstFinish =
        await _gameFinishService.getFirstFinish(itemId);
    final Duration totalTime = await _gameLogService.getTotalPlayedTime(itemId);

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
