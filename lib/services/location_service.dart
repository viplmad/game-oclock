import 'package:game_oclock/models/models.dart' show AggregateSearch;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class LocationService {
  final LocationsApi _api;

  LocationService(final ApiClient apiClient) : _api = LocationsApi(apiClient);

  Future<PageResultDTO<LocationDTO>> search(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getLocations(search, q: quicksearch);
  }

  Future<int> count(
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateLocationsWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<LocationAvailableDTO>> searchAvailable(
    final String gameId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getMediaLocations(gameId, search, q: quicksearch);
  }

  Future<int> countAvailable(
    final String gameId,
    final AggregateSearch search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaLocationsWithHttpInfo(
      gameId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<LocationDTO> get(final String id) async {
    return _api.getLocation(id);
  }

  Future<String> create(final NewLocationDTO location) async {
    return _api.createLocation(location);
  }

  Future<void> update(final String id, final NewLocationDTO location) async {
    return _api.updateLocation(id, location);
  }

  Future<void> delete(final String id) async {
    return _api.deleteLocation(id);
  }
}
