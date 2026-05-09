import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class DeviceService {
  final DevicesApi _api;

  DeviceService(final ApiClient apiClient) : _api = DevicesApi(apiClient);

  Future<PageResultDTO<DeviceDTO>> search(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getDevices(search, q: quicksearch);
  }

  Future<int> count(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateDevicesWithHttpInfo(
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<PageResultDTO<DeviceDTO>> searchPlayed(
    final String gameId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    return _api.getMediaDevices(gameId, search, q: quicksearch);
  }

  Future<int> countPlayed(
    final String gameId,
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaDevicesWithHttpInfo(
      gameId,
      AggregateSearchDTO(
        aggr: AggregateMetricDTO(field: 'id', kind: AggregateMetricType.count),
        filter: search.filter,
      ),
      q: quicksearch,
    );
    return convertAggrMetricResultToInt(_api.apiClient, response);
  }

  Future<DeviceDTO> get(final String id) async {
    return _api.getDevice(id);
  }

  Future<String> create(final NewDeviceDTO device) async {
    return _api.createDevice(device);
  }

  Future<void> update(final String id, final NewDeviceDTO device) async {
    return _api.updateDevice(id, device);
  }

  Future<void> delete(final String id) async {
    return _api.deleteDevice(id);
  }
}
