import 'package:game_oclock/models/models.dart' show AggregateSearch, idField;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class TagService {
  final TagsApi _api;

  TagService(ApiClient apiClient) : _api = TagsApi(apiClient);

  Future<PageResultDTO<TagDTO>> search(
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getTags(search, q: quicksearch);
  }

  Future<int> count(AggregateSearch search, String? quicksearch) async {
    final response = await _api.aggregateTagsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: idField.value,
          kind: AggregateMetricType.count,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<TagMediaDTO>> searchMediaTags(
    String gameId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getMediaTags(gameId, search, q: quicksearch);
  }

  Future<int> countMediaTags(
    String gameId,
    AggregateSearch search,
    String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaTagsWithHttpInfo(
      gameId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(
          field: idField.value,
          kind: AggregateMetricType.count,
        ),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<TagDTO> get(String id) async {
    return _api.getTag(id);
  }

  Future<String> create(NewTagDTO tag) async {
    return _api.createTag(tag);
  }

  Future<void> update(String id, NewTagDTO tag) async {
    return _api.updateTag(id, tag);
  }

  Future<void> delete(String id) async {
    return _api.deleteTag(id);
  }
}
