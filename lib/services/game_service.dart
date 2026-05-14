import 'package:game_oclock/models/models.dart' show AggregateSearch;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class GameService {
  final MediasApi _api;

  GameService(final ApiClient apiClient) : _api = MediasApi(apiClient);

  Future<PageResultDTO<MediaDTO>> search(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getMedias(search, q: quicksearch);
  }

  Future<int> count(
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateMediasWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<MediaAvailableDTO>> searchAvailable(
    final String locationId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getLocationMedias(locationId, search, q: quicksearch);
  }

  Future<int> countAvailable(
    final String locationId,
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateLocationMediasWithHttpInfo(
      locationId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<MediaTagDTO>> searchWithTag(
    final String tagId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getTagMedias(tagId, search, q: quicksearch);
  }

  Future<int> countWithTag(
    final String tagId,
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateTagMediasWithHttpInfo(
      tagId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<MediaDTO>> searchPlayedOnDevice(
    final String deviceId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getDeviceMedias(deviceId, search, q: quicksearch);
  }

  Future<int> countPlayedOnDevice(
    final String deviceId,
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateDeviceMediasWithHttpInfo(
      deviceId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<MediaDTO>> searchWithPlaythrough(
    final String playthroughId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<int> countWithPlaythrough(
    final String playthroughId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<void> addAvailability(
    final String gameId,
    final String locationId,
    final DateTime date,
  ) async {
    return _api.linkMediaLocation(
      gameId,
      locationId,
      DateTimeDTO(datetime: date),
    );
  }

  Future<void> addTag(final String gameId, final String tagId) async {
    return _api.linkMediaTag(gameId, tagId, OrderDTO());
  }

  Future<void> addPlaythrough(
    final String gameId,
    final String playthroughId,
  ) async {
    throw UnsupportedError('');
  }

  Future<MediaDTO> get(final String id) async {
    return _api.getMedia(id);
  }

  Future<String> create(final NewMediaDTO game) async {
    return _api.createMedia(game);
  }

  Future<void> update(final String id, final NewMediaDTO game) async {
    return _api.updateMedia(id, game);
  }

  Future<void> delete(final String id) async {
    return _api.deleteMedia(id);
  }
}
