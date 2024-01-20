import 'package:game_oclock_client/api.dart'
    show
        GameDTO,
        GamePageResult,
        GameStatus,
        GameWithFinishPageResult,
        GameWithLogPageResult,
        NewGameDTO;

import 'package:logic/model/model.dart' show GameView;
import 'package:logic/service/service.dart'
    show GameOClockService, GameFinishService, GameLogService, GameService;
import 'package:logic/preferences/shared_preferences_state.dart';

import 'item_list.dart';

class GameListBloc extends ItemListBloc<GameDTO, NewGameDTO, GameService> {
  GameListBloc({
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _gameFinishService = collectionService.gameFinishService,
        _gameLogService = collectionService.gameLogService,
        super(service: collectionService.gameService);

  final GameFinishService _gameFinishService;
  final GameLogService _gameLogService;

  @override
  Future<int> getStartViewIndex() async {
    return await SharedPreferencesState.retrieveInitialGameViewIndex() ??
        GameView.main.index;
  }

  @override
  Future<List<GameDTO>> getAllWithView(
    int viewIndex, [
    int? page,
  ]) async {
    final GameView view = GameView.values[viewIndex];
    switch (view) {
      case GameView.main:
        final GamePageResult result = await service.getAll(page: page);
        return result.data;
      case GameView.lastAdded:
        final GamePageResult result = await service.getLastAdded(page: page);
        return result.data;
      case GameView.lastUpdated:
        final GamePageResult result = await service.getLastUpdated(page: page);
        return result.data;
      case GameView.playing:
        final GamePageResult result =
            await service.getAllWithStatus(GameStatus.playing, page: page);
        return result.data;
      case GameView.nextUp:
        final GamePageResult result =
            await service.getAllWithStatus(GameStatus.nextUp, page: page);
        return result.data;
      case GameView.lastFinished:
        // null startDate = since the beginning of time
        final GameWithFinishPageResult result = await _gameFinishService
            .getLastFinishedGames(null, DateTime.now(), page: page);
        return result.data;
      case GameView.lastPlayed:
        // null startDate = since the beginning of time
        final GameWithLogPageResult result = await _gameLogService
            .getLastPlayedGames(null, DateTime.now(), page: page);
        return result.data;
    }
  }
}
