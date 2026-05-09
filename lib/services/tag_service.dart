import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class TagService {
  final TagsApi _api;

  TagService(final ApiClient apiClient) : _api = TagsApi(apiClient);

  Future<PageResultDTO<TagDTO>> search(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getTags(search, q: quicksearch);
  }

  Future<int> count(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateTagsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<TagMediaDTO>> searchMediaTags(
    final String gameId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getMediaTags(gameId, search, q: quicksearch);
  }

  Future<int> countMediaTags(
    final String gameId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaTagsWithHttpInfo(
      gameId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<TagDTO> get(final String id) async {
    return _api.getTag(id);
  }

  Future<String> create(final NewTagDTO tag) async {
    return _api.createTag(tag);
  }

  Future<void> update(final String id, final NewTagDTO tag) async {
    return _api.updateTag(id, tag);
  }

  Future<void> delete(final String id) async {
    return _api.deleteTag(id);
  }
}
