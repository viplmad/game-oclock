import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        ApiException,
        DLCFinishApi,
        DLCWithFinishPageResult,
        DateDTO,
        SearchDTO;

import 'package:backend/utils/http_status.dart';

import 'item_service.dart';

class DLCFinishService implements SecondaryItemService<DateTime, DateTime> {
  DLCFinishService(ApiClient apiClient) {
    _api = DLCFinishApi(apiClient);
  }

  late final DLCFinishApi _api;

  //#region CREATE
  @override
  Future<void> create(int primaryId, DateTime newItem) {
    return _api.postDlcFinish(primaryId, DateDTO(date: newItem));
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<DateTime>> getAll(int primaryId) {
    return _api.getDlcFinishes(primaryId);
  }

  Future<DateTime?> getFirstFinish(int primaryId) async {
    try {
      // TODO extract to method -> defaultIfNotFound
      return await _api.getFirstDlcFinish(primaryId);
    } on ApiException catch (e) {
      if (e.code == HttpStatus.notFound) {
        return Future<DateTime?>.value(null);
      }

      rethrow;
    }
  }

  Future<DLCWithFinishPageResult> getFirstFinishedDLCs(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getFirstFinishedDlcs(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<DLCWithFinishPageResult> getLastFinishedDLCs(
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return _api.getLastFinishedDlcs(
      SearchDTO(),
      startDate: startDate,
      endDate: endDate,
    );
  }
  //#endregion READ

  //#region DELETE
  @override
  Future<void> delete(int primaryId, DateTime id) {
    return _api.deleteDlcFinish(primaryId, DateDTO(date: id));
  }
  //#region DELETE
}
