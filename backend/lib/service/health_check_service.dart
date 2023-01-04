import 'package:game_collection_client/api.dart' show ApiClient, HealthCheckApi;

class HealthCheckService {
  HealthCheckService(ApiClient apiClient) {
    api = HealthCheckApi(apiClient);
  }

  late final HealthCheckApi api;

  Future<void> isAlive() {
    return api.isAlive();
  }
}
