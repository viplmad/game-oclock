import 'package:game_oclock_client/api.dart'
    show
        ApiClient,
        DateDTO,
        GameFinishApi,
        GameWithFinishPageResult,
        GamesFinishedReviewDTO,
        SearchDTO;

import 'item_service.dart';

class GameFinishService
    implements SecondaryItemService<DateTime, DateTime, DateTime> {
  GameFinishService(ApiClient apiClient) {
    _api = GameFinishApi(apiClient);
  }

  late final GameFinishApi _api;

  //#region CREATE
  @override
  Future<void> create(String primaryId, DateTime newItem) {
    return _api.postGameFinish(primaryId, DateDTO(date: newItem));
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<DateTime>> getAll(String primaryId) {
    return _api.getGameFinishes(primaryId);
  }

  Future<DateTime?> getFirstFinish(String primaryId) async {
    return nullIfNotFound(_api.getFirstGameFinish(primaryId));
  }

  Future<GameWithFinishPageResult> getFirstFinishedGames(
    DateTime? startDate,
    DateTime? endDate, {
    int? page,
    int? size,
  }) {
    return _api.getFirstFinishedGames(
      SearchDTO(page: page, size: size),
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<GameWithFinishPageResult> getLastFinishedGames(
    DateTime? startDate,
    DateTime? endDate, {
    int? page,
    int? size,
  }) {
    return _api.getLastFinishedGames(
      SearchDTO(page: page, size: size),
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<GamesFinishedReviewDTO> getReview(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _api.getFinishedGamesReview(startDate, endDate);
  }
  //#endregion READ

  //#region DELETE
  @override
  Future<void> delete(String primaryId, DateTime id) {
    return _api.deleteGameFinish(primaryId, DateDTO(date: id));
  }
  //#endregion DELETE
}
