import 'package:game_oclock/models/models.dart' show AggregateSearch, idField;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class GameService {
  final MediasApi _api;

  GameService(ApiClient apiClient) : _api = MediasApi(apiClient);

  Future<PageResultDTO<MediaDTO>> search(
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getMedias(search, q: quicksearch);
  }

  Future<int> count(AggregateSearch search, String? quicksearch) async {
    final response = await _api.aggregateMediasWithHttpInfo(
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

  Future<PageResultDTO<MediaAvailableDTO>> searchAvailable(
    String locationId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getLocationMedias(locationId, search, q: quicksearch);
  }

  Future<int> countAvailable(
    String locationId,
    AggregateSearch search,
    String? quicksearch,
  ) async {
    final response = await _api.aggregateLocationMediasWithHttpInfo(
      locationId,
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

  Future<PageResultDTO<MediaTagDTO>> searchWithTag(
    String tagId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getTagMedias(tagId, search, q: quicksearch);
  }

  Future<int> countWithTag(
    String tagId,
    AggregateSearch search,
    String? quicksearch,
  ) async {
    final response = await _api.aggregateTagMediasWithHttpInfo(
      tagId,
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

  Future<PageResultDTO<MediaDTO>> searchPlayedOnDevice(
    String deviceId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getDeviceMedias(deviceId, search, q: quicksearch);
  }

  Future<int> countPlayedOnDevice(
    String deviceId,
    AggregateSearch search,
    String? quicksearch,
  ) async {
    final response = await _api.aggregateDeviceMediasWithHttpInfo(
      deviceId,
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

  Future<PageResultDTO<MediaDTO>> searchWithPlaythrough(
    String playthroughId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<int> countWithPlaythrough(
    String playthroughId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    throw UnsupportedError('');
  }

  Future<void> addAvailability(
    String gameId,
    String locationId,
    DateTime date,
  ) async {
    return _api.linkMediaLocation(
      gameId,
      locationId,
      DateTimeDTO(datetime: date),
    );
  }

  Future<void> addTag(String gameId, String tagId) async {
    return _api.linkMediaTag(gameId, tagId, OrderDTO());
  }

  Future<void> addPlaythrough(String gameId, String playthroughId) async {
    throw UnsupportedError('');
  }

  Future<MediaDTO> get(String id) async {
    return _api.getMedia(id);
  }

  Future<String> create(NewMediaDTO game) async {
    return _api.createMedia(game);
  }

  Future<void> update(String id, NewMediaDTO game) async {
    return _api.updateMedia(id, game);
  }

  Future<void> delete(String id) async {
    return _api.deleteMedia(id);
  }

  Future<void> sync(String id) async {
    return _api.syncMedia(id);
  }

  Future<void> unsync(String id) async {
    return _api.unsyncMedia(id);
  }
}
