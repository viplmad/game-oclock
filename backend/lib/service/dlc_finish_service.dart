import 'package:game_collection_client/api.dart'
    show ApiClient, ApiException, DLCWithFinishSearchResult, DLCsApi, SearchDTO;

import 'package:backend/utils/http_status.dart';

import 'item_service.dart';

class DLCFinishService implements SecondaryItemService<DateTime, DateTime> {
  DLCFinishService(ApiClient apiClient) {
    _api = DLCsApi(apiClient);
  }

  late final DLCsApi _api; // TODO Move to dlcfinishapi?

  //#region CREATE
  @override
  Future<void> create(int primaryId, DateTime newItem) {
    return _api.postDlcFinish(primaryId, newItem);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<DateTime>> getAll(int primaryId) {
    return _api.getDlcFinishes(primaryId) as Future<List<DateTime>>;
  }

  Future<DateTime?> getFirstFinish(int primaryId) {
    try { // TODO extract to method -> defaultIfNotFound
      return _api.getFirstDlcFinish(primaryId) as Future<DateTime>;
    } on ApiException catch (e) {
      if (e.code == HttpStatus.notFound) {
        return Future<DateTime?>.value(null);
      }

      rethrow;
    }
  }

  Future<DLCWithFinishSearchResult> getFirstFinishedDLCs(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getFirstFinishedDlcs(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    ) as Future<DLCWithFinishSearchResult>;
  }

  Future<DLCWithFinishSearchResult> getLastFinishedDLCs(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getLastFinishedDlcs(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    ) as Future<DLCWithFinishSearchResult>;
  }
  //#endregion READ

  //#region DELETE
  @override
  Future<void> delete(int primaryId, DateTime id) {
    return _api.deleteDlcFinish(primaryId, id);
  }
  //#region DELETE
}
