import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        ApiException,
        DateDTO,
        GameFinishApi,
        GameWithFinishPageResult,
        SearchDTO;

import 'package:backend/utils/http_status.dart';

import 'item_service.dart';

class GameFinishService implements SecondaryItemService<DateTime, DateTime> {
  GameFinishService(ApiClient apiClient) {
    _api = GameFinishApi(apiClient);
  }

  late final GameFinishApi _api;

  //#region CREATE
  @override
  Future<void> create(int primaryId, DateTime newItem) {
    return _api.postGameFinish(primaryId, DateDTO(date: newItem));
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<DateTime>> getAll(int primaryId) {
    return _api.getGameFinishes(primaryId);
  }

  Future<DateTime?> getFirstFinish(int primaryId) async {
    try {
      return await _api.getFirstGameFinish(primaryId);
    } on ApiException catch (e) {
      if (e.code == HttpStatus.notFound) {
        return Future<DateTime?>.value(null);
      }

      rethrow;
    }
  }

  Future<GameWithFinishPageResult> getFirstFinishedGames(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getFirstFinishedGames(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<GameWithFinishPageResult> getLastFinishedGames(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getLastFinishedGames(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    );
  }
  //#endregion READ

  //#region DELETE
  @override
  Future<void> delete(int primaryId, DateTime id) {
    return _api.deleteGameFinish(primaryId, DateDTO(date: id));
  }
  //#endregion DELETE
}
