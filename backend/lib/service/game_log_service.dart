import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        DateTimeDTO,
        GameLogDTO,
        GameLogsApi,
        GameWithLogPageResult,
        GameWithLogsDTO,
        SearchDTO;

import 'item_service.dart';

class GameLogService implements SecondaryItemService<DateTime, GameLogDTO> {
  GameLogService(ApiClient apiClient) {
    _api = GameLogsApi(apiClient);
  }

  late final GameLogsApi _api;

  //#region CREATE
  @override
  Future<void> create(int primaryId, GameLogDTO newItem) {
    return _api.postGameLog(primaryId, newItem);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<GameLogDTO>> getAll(int primaryId) {
    return _api.getGameLogs(primaryId);
  }

  Future<Duration> getTotalPlayedTime(int primaryId) {
    return _api.getTotalGameLogs(primaryId);
  }

  Future<GameWithLogPageResult> getFirstPlayedGames(
    DateTime? startDate,
    DateTime? endDate, {
    int? page,
    int? size,
  }) {
    return _api.getFirstPlayedGames(
      SearchDTO(page: page, size: size),
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<GameWithLogPageResult> getLastPlayedGames(
    DateTime? startDate,
    DateTime? endDate, {
    int? page,
    int? size,
  }) {
    return _api.getLastPlayedGames(
      SearchDTO(page: page, size: size),
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<GameWithLogsDTO>> getPlayedGames(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _api.getPlayedGames(startDate, endDate);
  }
  //#endregion READ

  //#region DELETE
  @override
  Future<void> delete(int primaryId, DateTime id) {
    return _api.deleteGameLog(primaryId, DateTimeDTO(datetime: id));
  }
  //#endregion DELETE
}
