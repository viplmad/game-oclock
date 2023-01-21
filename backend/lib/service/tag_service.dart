import 'package:game_collection_client/api.dart'
    show
        ApiClient,
        NewTagDTO,
        OrderType,
        SearchDTO,
        SortDTO,
        TagDTO,
        TagPageResult,
        TagsApi;

import 'package:backend/model/model.dart' show TagView;

import 'item_service.dart';

class TagService implements ItemService<TagDTO, NewTagDTO> {
  TagService(ApiClient apiClient) {
    _api = TagsApi(apiClient);
  }

  late final TagsApi _api;

  //#region CREATE
  @override
  Future<TagDTO> create(NewTagDTO newItem) {
    return _api.postTag(newItem);
  }
  //#endregion CREATE

  //#region READ
  @override
  Future<TagDTO> get(int id) {
    return _api.getTag(id);
  }

  @override
  Future<TagPageResult> getAll<A>(
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
    return _api.getTags(
      SearchDTO(sort: sorts, page: page, size: size),
    );
  }

  @override
  Future<TagPageResult> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  }) {
    return _api.getTags(
      SearchDTO(page: page, size: size),
      q: quicksearch,
    );
  }

  Future<List<TagDTO>> getGameTags(int gameId) {
    return _api.getGameTags(gameId);
  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<TagDTO> update(int id, NewTagDTO updatedItem) {
    return _api.putTag(id, updatedItem);
  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<void> delete(int id) {
    return _api.deleteTag(id);
  }
  //#endregion DELETE
}
