import 'package:backend/model/model.dart' show PlatformView;
import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        DLCsApi,
        GamesApi,
        NewPlatformDTO,
        OrderType,
        PlatformAvailableDTO,
        PlatformDTO,
        PlatformSearchResult,
        PlatformsApi,
        SearchDTO,
        SortDTO;

import 'item_service.dart';

class PlatformService
    implements ItemWithImageService<PlatformDTO, NewPlatformDTO> {
  PlatformService(ApiClient apiClient) {
    api = PlatformsApi(apiClient);
    gamesApi = GamesApi(apiClient);
    dlcsApi = DLCsApi(apiClient);
  }

  late final PlatformsApi api;
  late final GamesApi gamesApi; // TODO
  late final DLCsApi dlcsApi; // TODO

  @override
  bool sameId(PlatformDTO one, PlatformDTO other) {
    return one.id == other.id;
  }

  //#region CREATE
  @override
  Future<PlatformDTO> create(NewPlatformDTO newItem) {
    return api.postPlatform(newItem) as Future<PlatformDTO>;
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<PlatformDTO> get(int id) {
    return api.getPlatform(id) as Future<PlatformDTO>;
  }

  Future<PlatformSearchResult> getAll<A>(
    int viewIndex, {
    int? page,
    int? size,
    A? viewArgs,
  }) {
    final PlatformView view = PlatformView.values[viewIndex];
    final List<SortDTO> sorts = <SortDTO>[];
    switch (view) {
      case PlatformView.main:
        sorts.add(SortDTO(field: 'type', order: OrderType.asc));
        sorts.add(SortDTO(field: 'name', order: OrderType.asc));
        break;
      case PlatformView.lastAdded:
        sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));
        break;
      case PlatformView.lastUpdated:
        sorts.add(SortDTO(field: 'updated_datetime', order: OrderType.desc));
        break;
    }
    return api.getPlatforms(
      SearchDTO(sort: sorts, page: page, size: size),
    ) as Future<PlatformSearchResult>;
  }

  @override
  Future<PlatformSearchResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return api.getPlatforms(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    ) as Future<PlatformSearchResult>;
  }

  Future<List<PlatformAvailableDTO>> getGameAvailablePlatforms(int gameId) {
    return gamesApi.getGamePlatforms(gameId)
        as Future<List<PlatformAvailableDTO>>; // TODO Move to platforms api
  }

  Future<List<PlatformAvailableDTO>> getDLCAvailablePlatforms(int dlcId) {
    return dlcsApi.getDlcPlatforms(dlcId)
        as Future<List<PlatformAvailableDTO>>; // TODO Move to platforms api
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<PlatformDTO> update(int id, NewPlatformDTO updatedItem) {
    return api.putPlatform(id, updatedItem) as Future<PlatformDTO>;
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<void> delete(int id) {
    return api.deletePlatform(id);
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
