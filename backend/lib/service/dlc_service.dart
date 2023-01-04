import 'package:backend/model/model.dart' show DLCView;
import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        DLCAvailableDTO,
        DLCDTO,
        DLCSearchResult,
        DLCsApi,
        GamesApi,
        NewDLCDTO,
        OrderType,
        PlatformsApi,
        SearchDTO,
        SortDTO;

import 'item_service.dart';

class DLCService implements ItemWithImageService<DLCDTO, NewDLCDTO> {
  DLCService(ApiClient apiClient) {
    _api = DLCsApi(apiClient);
    gamesApi = GamesApi(apiClient);
    platformsApi = PlatformsApi(apiClient);
  }

  late final DLCsApi _api;
  late final GamesApi gamesApi; // TODO Move to dlcsapi?
  late final PlatformsApi platformsApi; // TODO Move to dlcsapi?

  @override
  bool sameId(DLCDTO one, DLCDTO other) {
    return one.id == other.id;
  }

  //#region CREATE
  @override
  Future<DLCDTO> create(NewDLCDTO newItem) {
    return _api.postDlc(newItem) as Future<DLCDTO>;
  }

  Future<void> addAvailability(int id, int platformId, DateTime date) {
    return _api.linkDlcPlatform(id, platformId, date);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<DLCDTO> get(int id) {
    return _api.getDlc(id) as Future<DLCDTO>;
  }

  @override
  Future<DLCSearchResult> getAll<A>(
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
    ) as Future<DLCSearchResult>;
  }

  @override
  Future<DLCSearchResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return _api.getDlcs(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    ) as Future<DLCSearchResult>;
  }

  Future<List<DLCDTO>> getGameDLCs(int gameId) {
    return gamesApi.getGameDlcs(gameId)
        as Future<List<DLCDTO>>; // TODO Move to dlcsapi?
  }

  Future<List<DLCAvailableDTO>> getPlatformAvailableDLCs(int platformId) {
    return platformsApi.getPlatformDlcs(platformId)
        as Future<List<DLCAvailableDTO>>; // TODO Move to dlcsapi?
  }
  //#endregion CREATE

  //#region UPDATE
  @override
  Future<DLCDTO> update(int id, NewDLCDTO updatedItem) {
    return _api.putDlc(id, updatedItem) as Future<DLCDTO>;
  }

  Future<void> setBasegame(int id, int gameId) {
    return gamesApi.linkGameDlc(gameId, id); // TODO Move to dlcsapi
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
    throw UnimplementedError();
    //return gamesApi.unlinkGameDlc(null, id); // TODO Move to dlcsapi?
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
    String imageName,
    String newImageName,
  ) {
    return get(id); // TODO
  }

  @override
  Future<void> deleteImage(int id, String imageName) {
    return get(id); // TODO
  }
  //#endregion IMAGE
}
