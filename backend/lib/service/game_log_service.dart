import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        GameLogDTO,
        GameWithLogSearchResult,
        GameWithLogsDTO,
        GamesApi,
        SearchDTO;

import 'item_service.dart';

class GameLogService implements SecondaryItemService<DateTime, GameLogDTO> {
  GameLogService(ApiClient apiClient) {
    _api = GamesApi(apiClient);
  }

  late final GamesApi _api; // TODO Move to GameLogs api

  //#region CREATE
  @override
  Future<void> create(int primaryId, GameLogDTO newItem) {
    return _api.postGameLog(primaryId, newItem);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<GameLogDTO>> getAll(int primaryId) {
    return _api.getGameLogs(primaryId) as Future<List<GameLogDTO>>;
  }

  Future<Duration> getTotalPlayedTime(int primaryId) {
    return _api.getTotalGameLogs(primaryId) as Future<Duration>;
  }

  Future<GameWithLogSearchResult> getFirstFinishedDLCs(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getFirstPlayedGames(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    ) as Future<GameWithLogSearchResult>;
  }

  Future<GameWithLogSearchResult> getLastFinishedDLCs(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getLastPlayedGames(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    ) as Future<GameWithLogSearchResult>;
  }

  Future<List<GameWithLogsDTO>> getPlayedGames(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _api.getPlayedGames(startDate, endDate)
        as Future<List<GameWithLogsDTO>>;
  }
  //#endregion READ

  //#region DELETE
  @override
  Future<void> delete(int primaryId, DateTime id) {
    return _api.deleteGameLog(primaryId, id);
  }
  //#endregion DELETE
}
