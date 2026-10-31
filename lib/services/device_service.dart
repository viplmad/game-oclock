import 'package:game_oclock/models/models.dart' show AggregateSearch, idField;
import 'package:game_oclock_client/api.dart';

import 'utils.dart';

class DeviceService {
  final DevicesApi _api;

  DeviceService(ApiClient apiClient) : _api = DevicesApi(apiClient);

  Future<PageResultDTO<DeviceDTO>> search(
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getDevices(search, q: quicksearch);
  }

  Future<int> count(AggregateSearch search, String? quicksearch) async {
    final response = await _api.aggregateDevicesWithHttpInfo(
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

  Future<PageResultDTO<DeviceDTO>> searchPlayed(
    String gameId,
    ListSearchDTO search,
    String? quicksearch,
  ) async {
    return _api.getMediaDevices(gameId, search, q: quicksearch);
  }

  Future<int> countPlayed(
    String gameId,
    AggregateSearch search,
    String? quicksearch,
  ) async {
    final response = await _api.aggregateMediaDevicesWithHttpInfo(
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

  Future<DeviceDTO> get(String id) async {
    return _api.getDevice(id);
  }

  Future<String> create(NewDeviceDTO device) async {
    return _api.createDevice(device);
  }

  Future<void> update(String id, NewDeviceDTO device) async {
    return _api.updateDevice(id, device);
  }

  Future<void> delete(String id) async {
    return _api.deleteDevice(id);
  }
}
