import 'package:http/http.dart';

import 'package:game_oclock_client/api.dart'
    show
        ApiClient,
        DLCsApi,
        DateDTO,
        FilterDTO,
        GameAvailableDTO,
        GameDTO,
        GamePageResult,
        GameStatus,
        GamesApi,
        NewGameDTO,
        OperatorType,
        OrderType,
        SearchDTO,
        SearchValue,
        SortDTO;

import 'package:logic/utils/http_utils.dart';

import 'item_service.dart';

class GameService implements ItemWithImageService<GameDTO, NewGameDTO> {
  GameService(ApiClient apiClient) {
    _api = GamesApi(apiClient);
    _dlcsApi = DLCsApi(apiClient);
  }

  late final GamesApi _api;
  late final DLCsApi _dlcsApi;

  //#region CREATE
  @override
  Future<GameDTO> create(NewGameDTO newItem) {
    return _api.postGame(newItem);
  }

  Future<void> addAvailability(String id, String platformId, DateTime date) {
    return _api.linkGamePlatform(id, platformId, DateDTO(date: date));
  }

  Future<void> tag(String id, String tagId) {
    return _api.linkGameTag(id, tagId);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<GameDTO> get(String id) {
    return _api.getGame(id);
  }

  @override
  Future<GamePageResult> getAll({
    int? page,
    int? size,
  }) {
    // Exclude wishlisted
    final List<FilterDTO> filters = <FilterDTO>[];
    filters.add(
      FilterDTO(
        field: 'status',
        operator_: OperatorType.notEq,
        value: SearchValue(value: GameStatus.wishlist.value),
      ),
    );

    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'release_year', order: OrderType.asc));
    sorts.add(SortDTO(field: 'name', order: OrderType.asc));

    return _api.getGames(
      SearchDTO(filter: filters, sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<GamePageResult> getLastAdded({
    int? page,
    int? size,
  }) {
    // Exclude wishlisted
    final List<FilterDTO> filters = <FilterDTO>[];
    filters.add(
      FilterDTO(
        field: 'status',
        operator_: OperatorType.notEq,
        value: SearchValue(value: GameStatus.wishlist.value),
      ),
    );

    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));

    return _api.getGames(
      SearchDTO(filter: filters, sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<GamePageResult> getLastUpdated({
    int? page,
    int? size,
  }) {
    // Exclude wishlisted
    final List<FilterDTO> filters = <FilterDTO>[];
    filters.add(
      FilterDTO(
        field: 'status',
        operator_: OperatorType.notEq,
        value: SearchValue(value: GameStatus.wishlist.value),
      ),
    );

    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'updated_datetime', order: OrderType.desc));

    return _api.getGames(
      SearchDTO(filter: filters, sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<GamePageResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return _api.getGames(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    );
  }

  Future<GamePageResult> getAllWithStatus(
    GameStatus status, {
    int? page,
    int? size,
  }) {
    final List<FilterDTO> filters = <FilterDTO>[];
    filters.add(
      FilterDTO(
        field: 'status',
        operator_: OperatorType.eq,
        value: SearchValue(value: status.value),
      ),
    );

    final List<SortDTO> sorts = <SortDTO>[];
    sorts.add(SortDTO(field: 'release_year', order: OrderType.asc));
    sorts.add(SortDTO(field: 'name', order: OrderType.asc));

    return _api.getGames(
      SearchDTO(filter: filters, sort: sorts, page: page, size: size),
    );
  }

  Future<GameDTO> _getDLCBasegame(String dlcId) {
    return _dlcsApi.getDlcBaseGame(dlcId);
  }

  Future<List<GameDTO>> getDLCBasegameAsList(String dlcId) {
    return defaultIfNotFound(
      _getDLCBasegame(dlcId)
          .asStream()
          .map(
            (GameDTO game) => <GameDTO>[game],
          )
          .first,
      <GameDTO>[],
    );
  }

  Future<List<GameAvailableDTO>> getPlatformAvailableGames(String platformId) {
    return _api.getPlatformGames(platformId);
  }

  Future<List<GameDTO>> getTaggedGames(String tagId) {
    return _api.getTagGames(tagId);
  }
  //#endregion CREATE

  //#region UPDATE
  @override
  Future<void> update(String id, NewGameDTO updatedItem) {
    return _api.putGame(id, updatedItem);
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<void> delete(String id) {
    return _api.deleteGame(id);
  }

  Future<void> removeAvailability(String id, String platformId) {
    return _api.unlinkGamePlatform(id, platformId);
  }

  Future<void> untag(String id, String tagId) {
    return _api.unlinkGameTag(id, tagId);
  }
  //#endregion DELETE

  //#region IMAGE
  @override
  Future<void> uploadImage(
    String id,
    String uploadImagePath,
  ) async {
    final MultipartFile file =
        await HttpUtils.createMultipartImageFile(uploadImagePath);
    return _api.postGameCover(id, file);
  }

  @override
  Future<void> renameImage(
    String id,
    String newImageName,
  ) {
    return _api.putGameCover(id, newImageName);
  }

  @override
  Future<void> deleteImage(String id) {
    return _api.deleteGameCover(id);
  }
  //#endregion IMAGE
}
