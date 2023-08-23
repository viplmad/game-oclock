import 'package:game_collection_client/api.dart'
    show ApiClient, DLCFinishApi, DLCWithFinishPageResult, DateDTO, SearchDTO;

import 'item_service.dart';

class DLCFinishService
    implements SecondaryItemService<DateTime, DateTime, DateTime> {
  DLCFinishService(ApiClient apiClient) {
    _api = DLCFinishApi(apiClient);
  }

  late final DLCFinishApi _api;

  //#region CREATE
  @override
  Future<void> create(String primaryId, DateTime newItem) {
    return _api.postDlcFinish(primaryId, DateDTO(date: newItem));
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<DateTime>> getAll(String primaryId) {
    return _api.getDlcFinishes(primaryId);
  }

  Future<DateTime?> getFirstFinish(String primaryId) async {
    return nullIfNotFound(_api.getFirstDlcFinish(primaryId));
  }

  Future<DLCWithFinishPageResult> getFirstFinishedDLCs(
    DateTime? startDate,
    DateTime? endDate, {
    int? page,
    int? size,
  }) {
    return _api.getFirstFinishedDlcs(
      SearchDTO(page: page, size: size),
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<DLCWithFinishPageResult> getLastFinishedDLCs(
    DateTime? startDate,
    DateTime? endDate, {
    int? page,
    int? size,
  }) {
    return _api.getLastFinishedDlcs(
      SearchDTO(page: page, size: size),
      startDate: startDate,
      endDate: endDate,
    );
  }
  //#endregion READ

  //#region DELETE
  @override
  Future<void> delete(String primaryId, DateTime id) {
    return _api.deleteDlcFinish(primaryId, DateDTO(date: id));
  }
  //#region DELETE
}
