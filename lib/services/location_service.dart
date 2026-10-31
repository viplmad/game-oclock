import 'package:game_oclock/models/models.dart' show AggregateSearch, idField;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class LocationService {
  final LocationsApi _api;

  LocationService(ApiClient apiClient) : _api = LocationsApi(apiClient);

  Future<PageResultDTO<LocationDTO>> search(
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getLocations(search, q: quicksearch);
  }

  Future<int> count(AggregateSearch search, String? quicksearch) async {
    final response = await _api.aggregateLocationsWithHttpInfo(
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

  Future<PageResultDTO<LocationAvailableDTO>> searchAvailable(
    String gameId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getMediaLocations(gameId, search, q: quicksearch);
  }

  Future<int> countAvailable(
    String gameId,
    AggregateSearch search,
    String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaLocationsWithHttpInfo(
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

  Future<LocationDTO> get(String id) async {
    return _api.getLocation(id);
  }

  Future<String> create(NewLocationDTO location) async {
    return _api.createLocation(location);
  }

  Future<void> update(String id, NewLocationDTO location) async {
    return _api.updateLocation(id, location);
  }

  Future<void> delete(String id) async {
    return _api.deleteLocation(id);
  }
}
