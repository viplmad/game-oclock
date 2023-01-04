import 'package:backend/model/model.dart' show TagView;
import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        GamesApi,
        NewTagDTO,
        OrderType,
        SearchDTO,
        SortDTO,
        TagDTO,
        TagSearchResult,
        TagsApi;

import 'item_service.dart';

class TagService implements ItemService<TagDTO, NewTagDTO> {
  TagService(ApiClient apiClient) {
    api = TagsApi(apiClient);
    gamesApi = GamesApi(apiClient);
  }

  late final TagsApi api;
  late final GamesApi gamesApi; // TODO Move to tagsapi?

  @override
  bool sameId(TagDTO one, TagDTO other) {
    return one.id == other.id;
  }

  //#region CREATE
  @override
  Future<TagDTO> create(NewTagDTO newItem) {
    return api.postTag(newItem) as Future<TagDTO>;
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<TagDTO> get(int id) {
    return api.getTag(id) as Future<TagDTO>;
  }

  @override
  Future<TagSearchResult> getAll<A>(
    int viewIndex, {
    int? page,
    int? size,
    A? viewArgs,
  }) {
    final TagView view = TagView.values[viewIndex];
    final List<SortDTO> sorts = <SortDTO>[];
    switch (view) {
      case TagView.main:
        sorts.add(SortDTO(field: 'name', order: OrderType.asc));
        break;
      case TagView.lastAdded:
        sorts.add(SortDTO(field: 'added_datetime', order: OrderType.desc));
        break;
      case TagView.lastUpdated:
        sorts.add(SortDTO(field: 'updated_datetime', order: OrderType.desc));
        break;
    }
    return api.getTags(
      SearchDTO(sort: sorts, page: page, size: size),
    ) as Future<TagSearchResult>;
  }

  @override
  Future<TagSearchResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return api.getTags(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    ) as Future<TagSearchResult>;
  }

  Future<List<TagDTO>> getGameTags(int gameId) {
    return gamesApi.getGameTags(gameId) as Future<List<TagDTO>>;
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<TagDTO> update(int id, NewTagDTO updatedItem) {
    return api.putTag(id, updatedItem) as Future<TagDTO>;
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<void> delete(int id) {
    return api.deleteTag(id);
  }
  //#endregion DELETE
}
