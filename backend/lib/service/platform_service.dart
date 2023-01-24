import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        NewPlatformDTO,
        OrderType,
        PlatformAvailableDTO,
        PlatformDTO,
        PlatformPageResult,
        PlatformsApi,
        SearchDTO,
        SortDTO;

import 'item_service.dart';

class PlatformService
    implements ItemWithImageService<PlatformDTO, NewPlatformDTO> {
  PlatformService(ApiClient apiClient) {
    _api = PlatformsApi(apiClient);
  }

  late final PlatformsApi _api;

  //#region CREATE
  @override
  Future<PlatformDTO> create(NewPlatformDTO newItem) {
    return _api.postPlatform(newItem);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<PlatformDTO> get(int id) {
    return _api.getPlatform(id);
  }

  @override
  Future<PlatformPageResult> getAll({
    int? page,
    int? size,
  }) {
    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'type', order: OrderType.asc));
    sorts.add(SortDTO(field: 'name', order: OrderType.asc));

    return _api.getPlatforms(
      SearchDTO(sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<PlatformPageResult> getLastAdded({
    int? page,
    int? size,
  }) {
    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));

    return _api.getPlatforms(
      SearchDTO(sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<PlatformPageResult> getLastUpdated({
    int? page,
    int? size,
  }) {
    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'updated_datetime', order: OrderType.desc));

    return _api.getPlatforms(
      SearchDTO(sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<PlatformPageResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return _api.getPlatforms(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    );
  }

  Future<List<PlatformAvailableDTO>> getGameAvailablePlatforms(int gameId) {
    return _api.getGamePlatforms(gameId);
  }

  Future<List<PlatformAvailableDTO>> getDLCAvailablePlatforms(int dlcId) {
    return _api.getDlcPlatforms(dlcId);
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<PlatformDTO> update(int id, NewPlatformDTO updatedItem) {
    return _api.putPlatform(id, updatedItem);
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<void> delete(int id) {
    return _api.deletePlatform(id);
  }
  //#endregion DELETE

  //#region IMAGE
  @override
  Future<void> uploadImage(
    int id,
    String uploadImagePath,
  ) {
    return _api.postPlatformIcon(id);
  }

  @override
  Future<void> renameImage(
    int id,
    String newImageName,
  ) {
    return _api.putPlatformIcon(id, newImageName);
  }

  @override
  Future<void> deleteImage(int id) {
    return _api.deletePlatformIcon(id);
  }
  //#endregion IMAGE
}
