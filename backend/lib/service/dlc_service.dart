import 'package:backend/model/model.dart' show DLCView;
import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        DLCAvailableDTO,
        DLCDTO,
        DLCPageResult,
        DLCsApi,
        DateDTO,
        NewDLCDTO,
        OrderType,
        SearchDTO,
        SortDTO;

import 'item_service.dart';

class DLCService implements ItemWithImageService<DLCDTO, NewDLCDTO> {
  DLCService(ApiClient apiClient) {
    _api = DLCsApi(apiClient);
  }

  late final DLCsApi _api;

  //#region CREATE
  @override
  Future<DLCDTO> create(NewDLCDTO newItem) {
    return _api.postDlc(newItem);
  }

  Future<void> addAvailability(int id, int platformId, DateTime date) {
    return _api.linkDlcPlatform(id, platformId, DateDTO(date: date));
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<DLCDTO> get(int id) {
    return _api.getDlc(id);
  }

  @override
  Future<DLCPageResult> getAll<A>(
    int viewIndex, {
    int? page,
    int? size,
    A? viewArgs,
  }) {
    final DLCView view = DLCView.values[viewIndex];
    final List<SortDTO> sorts = <SortDTO>[];
    switch (view) {
      case DLCView.main:
        sorts.add(SortDTO(field: 'base_game_id', order: OrderType.asc));
        sorts.add(SortDTO(field: 'release_year', order: OrderType.asc));
        sorts.add(SortDTO(field: 'name', order: OrderType.asc));
        break;
      case DLCView.lastAdded:
        sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));
        break;
      case DLCView.lastUpdated:
        sorts.add(SortDTO(field: 'updated_datetime', order: OrderType.desc));
        break;
    }
    return _api.getDlcs(
      SearchDTO(sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<DLCPageResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return _api.getDlcs(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    );
  }

  Future<List<DLCDTO>> getGameDLCs(int gameId) {
    return _api.getGameDlcs(gameId);
  }

  Future<List<DLCAvailableDTO>> getPlatformAvailableDLCs(int platformId) {
    return _api.getPlatformDlcs(platformId);
  }
  //#endregion CREATE

  //#region UPDATE
  @override
  Future<DLCDTO> update(int id, NewDLCDTO updatedItem) {
    return _api.putDlc(id, updatedItem);
  }

  Future<void> setBasegame(int id, int gameId) {
    return _api.linkDlcGame(id, gameId);
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<void> delete(int id) {
    return _api.deleteDlc(id);
  }

  Future<void> removeAvailability(int id, int platformId) {
    return _api.unlinkDlcPlatform(id, platformId);
  }

  Future<void> clearBasegame(int id) {
    return _api.unlinkDlcGame(id);
  }
  //#endregion DELETE

  //#region IMAGE
  @override
  Future<void> uploadImage(
    int id,
    String uploadImagePath,
  ) {
    return get(id); // TODO
  }

  @override
  Future<void> renameImage(
    int id,
    String newImageName,
  ) {
    return get(id); // TODO
  }

  @override
  Future<void> deleteImage(int id) {
    return get(id); // TODO
  }
  //#endregion IMAGE
}
