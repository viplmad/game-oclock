import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        ApiException,
        GameWithFinishSearchResult,
        GamesApi,
        SearchDTO;

import 'package:backend/utils/http_status.dart';

import 'item_service.dart';

class GameFinishService implements SecondaryItemService<DateTime, DateTime> {
  GameFinishService(ApiClient apiClient) {
    _api = GamesApi(apiClient);
  }

  late final GamesApi _api; // TODO Move to gamefinishapi?

  //#region CREATE
  @override
  Future<void> create(int primaryId, DateTime newItem) {
    return _api.postGameFinish(primaryId, newItem);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<DateTime>> getAll(int primaryId) {
    return _api.getGameFinishes(primaryId) as Future<List<DateTime>>;
  }

  Future<DateTime?> getFirstFinish(int primaryId) {
    try {
      return _api.getFirstGameFinish(primaryId) as Future<DateTime>;
    } on ApiException catch (e) {
      if (e.code == HttpStatus.notFound) {
        return Future<DateTime?>.value(null);
      }

      rethrow;
    }
  }

  Future<GameWithFinishSearchResult> getFirstFinishedGames(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getFirstFinishedGames(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    ) as Future<GameWithFinishSearchResult>;
  }

  Future<GameWithFinishSearchResult> getLastFinishedGames(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getLastFinishedGames(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    ) as Future<GameWithFinishSearchResult>;
  }
  //#endregion READ

  //#region DELETE
  @override
  Future<void> delete(int primaryId, DateTime id) {
    return _api.deleteGameFinish(primaryId, id);
  }
  //#endregion DELETE
}
