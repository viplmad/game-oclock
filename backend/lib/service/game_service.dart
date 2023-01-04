import 'package:backend/model/model.dart' show GameView;
import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        ApiException,
        DLCsApi,
        FilterDTO,
        GameAvailableDTO,
        GameDTO,
        GameSearchResult,
        GameStatus,
        GamesApi,
        NewGameDTO,
        OperatorType,
        OrderType,
        PlatformsApi,
        SearchDTO,
        SearchValue,
        SortDTO,
        TagsApi;

import '../utils/http_status.dart';
import 'item_service.dart';

class GameService implements ItemWithImageService<GameDTO, NewGameDTO> {
  GameService(ApiClient apiClient) {
    api = GamesApi(apiClient);
    dlcsApi = DLCsApi(apiClient);
    platformsApi = PlatformsApi(apiClient);
    tagsApi = TagsApi(apiClient);
  }

  late final GamesApi api;
  late final DLCsApi dlcsApi; // TODO Move calls to game service
  late final PlatformsApi platformsApi; // TODO Move calls to game service
  late final TagsApi tagsApi; // TODO Move calls to game service

  @override
  bool sameId(GameDTO one, GameDTO other) {
    return one.id == other.id;
  }

  //#region CREATE
  @override
  Future<GameDTO> create(NewGameDTO newItem) {
    return api.postGame(newItem) as Future<GameDTO>;
  }

  Future<void> addAvailability(int id, int platformId, DateTime date) {
    return api.linkGamePlatform(id, platformId, date);
  }

  Future<void> tag(int id, int tagId) {
    return api.linkGameTag(id, tagId);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<GameDTO> get(int id) {
    return api.getGame(id) as Future<GameDTO>;
  }

  @override
  Future<GameSearchResult> getAll<A>(
    int viewIndex, {
    int? page,
    int? size,
    A? viewArgs,
  }) {
    final GameView view = GameView.values[viewIndex];
    final List<FilterDTO> filters = <FilterDTO>[];
    final List<SortDTO> sorts = <SortDTO>[];
    switch (view) {
      case GameView.main:
        sorts.add(SortDTO(field: 'release_year', order: OrderType.asc));
        sorts.add(SortDTO(field: 'name', order: OrderType.asc));
        break;
      case GameView.lastAdded:
        sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));
        break;
      case GameView.lastUpdated:
        sorts.add(SortDTO(field: 'updated_datetime', order: OrderType.desc));
        break;
      case GameView.playing:
        filters.add(
          FilterDTO(
            field: 'status',
            operator_: OperatorType.eq,
            value: SearchValue(value: GameStatus.playing.value),
          ),
        );

        sorts.add(SortDTO(field: 'release_year', order: OrderType.asc));
        sorts.add(SortDTO(field: 'name', order: OrderType.asc));
        break;
      case GameView.nextUp:
        filters.add(
          FilterDTO(
            field: 'status',
            operator_: OperatorType.eq,
            value: SearchValue(value: GameStatus.nextUp.value),
          ),
        );

        sorts.add(SortDTO(field: 'release_year', order: OrderType.asc));
        sorts.add(SortDTO(field: 'name', order: OrderType.asc));
        break;
    }
    return api.getGames(
      SearchDTO(filter: filters, sort: sorts, page: page, size: size),
    ) as Future<GameSearchResult>;
  }

  @override
  Future<GameSearchResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return api.getGames(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    ) as Future<GameSearchResult>;
  }

  Future<GameDTO> getDLCBasegame(int dlcId) {
    return dlcsApi.getDlcBaseGame(dlcId) as Future<GameDTO>;
  }

  Future<List<GameDTO>> getDLCBasegameAsList(int dlcId) {
    try {
      return getDLCBasegame(dlcId)
          .asStream()
          .map(
            (GameDTO game) => <GameDTO>[game],
          )
          .first;
    } on ApiException catch (e) {
      if (e.code == HttpStatus.notFound) {
        return Future<List<GameDTO>>.value(<GameDTO>[]);
      }

      rethrow;
    }
  }

  Future<List<GameAvailableDTO>> getPlatformAvailableGames(int platformId) {
    return platformsApi.getPlatformGames(platformId)
        as Future<List<GameAvailableDTO>>; // TODO Move to gamesapi?
  }

  Future<List<GameDTO>> getTaggedGames(int tagId) {
    return tagsApi.getTagGames(tagId)
        as Future<List<GameDTO>>; // TODO Move to gamesapi?
  }
  //#endregion CREATE

  //#region UPDATE
  @override
  Future<GameDTO> update(int id, NewGameDTO updatedItem) {
    return api.putGame(id, updatedItem) as Future<GameDTO>;
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<void> delete(int id) {
    return api.deleteGame(id);
  }

  Future<void> removeAvailability(int id, int platformId) {
    return api.unlinkGamePlatform(id, platformId);
  }

  Future<void> untag(int id, int tagId) {
    return api.unlinkGameTag(id, tagId);
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
