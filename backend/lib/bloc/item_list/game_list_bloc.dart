import 'package:game_collection_client/api.dart'
    show
        GameDTO,
        GamePageResult,
        GameStatus,
        GameWithFinishPageResult,
        GameWithLogPageResult,
        NewGameDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameFinishService, GameLogService, GameService;
import 'package:logic/model/model.dart' show GameView;
import 'package:logic/preferences/shared_preferences_state.dart';
import 'package:logic/utils/datetime_extension.dart';

import 'item_list.dart';

class GameListBloc extends ItemListBloc<GameDTO, NewGameDTO, GameService> {
  GameListBloc({
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : gameFinishService = collectionService.gameFinishService,
        gameLogService = collectionService.gameLogService,
        super(service: collectionService.gameService);

  final GameFinishService gameFinishService;
  final GameLogService gameLogService;

  @override
  Future<ViewParameters> getStartViewIndex() async {
    final int startViewIndex =
        await SharedPreferencesState.retrieveInitialGameViewIndex() ??
            GameView.main.index;

    return ViewParameters(
      startViewIndex,
      startViewIndex == GameView.review.index ? DateTime.now().year : null,
    );
  }

  @override
  Future<List<GameDTO>> getAllWithView(
    int viewIndex,
    Object? viewArgs, [
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
        final GameWithFinishPageResult result = await gameFinishService
            .getLastFinishedGames(null, DateTime.now(), page: page);
        return result.data;
      case GameView.lastPlayed:
        // null startDate = since the beginning of time
        final GameWithLogPageResult result = await gameLogService
            .getLastPlayedGames(null, DateTime.now(), page: page);
        return result.data;
      case GameView.review:
        final DateTime startDate = _getArgsStartDate(viewArgs);
        final DateTime endDate = startDate.atLastDayOfYear();

        final GameWithFinishPageResult result = await gameFinishService
            .getFirstFinishedGames(startDate, endDate, page: page);
        return result.data;
    }
  }

  DateTime _getArgsStartDate(Object? viewArgs) {
    DateTime startDate;
    if (viewArgs != null && viewArgs is int) {
      final int year = viewArgs;
      startDate = DateTime(year).atFirstDayOfYear();
    } else {
      startDate = DateTime.now().atFirstDayOfYear();
    }

    return startDate;
  }
}
