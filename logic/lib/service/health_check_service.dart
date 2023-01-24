import 'package:game_collection_client/api.dart' show ApiClient, HealthCheckApi;

class HealthCheckService {
  HealthCheckService(ApiClient apiClient) {
    _api = HealthCheckApi(apiClient);
  }

  late final HealthCheckApi _api;

  Future<void> health() {
    return _api.health();
  }
}
