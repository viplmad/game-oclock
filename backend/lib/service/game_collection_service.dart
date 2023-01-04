import 'package:game_collection_client/api.dart'
    show ApiClient, ApiException, OAuth, TokenResponse;

import 'package:backend/model/model.dart' show ServerConnection;

import '../utils/http_status.dart';
import 'service.dart';

class GameCollectionService {
  GameCollectionService();

  late LoginService loginService;
  late UserService userService;
  late GameService gameService;
  late GameFinishService gameFinishService;
  late GameLogService gameLogService;
  late DLCService dlcService;
  late DLCFinishService dlcFinishService;
  late PlatformService platformService;
  late TagService tagService;

  Future<TokenResponse> login(
    String host,
    String username,
    String password,
  ) {
    final ApiClient apiClient = ApiClient(basePath: host);
    final LoginService loginService = LoginService(apiClient);
    return loginService.login(username, password);
  }

  Future<TokenResponse?> testAuth(String refreshToken) async {
    try {
      await userService.getCurrentUser();
    } on ApiException catch (e) {
      if (e.code == HttpStatus.unauthorized) {
        return loginService.refreshToken(refreshToken);
      }
    }

    return null;
  }

  void connect(ServerConnection connection) {
    final ApiClient apiClient = ApiClient(
      basePath: connection.host,
      authentication: OAuth(
        accessToken: connection.tokenResponse.accessToken,
      ),
    );

    _connect(apiClient);
  }

  void _connect(ApiClient apiClient) {
    loginService = LoginService(apiClient);
    userService = UserService(apiClient);
    gameService = GameService(apiClient); // TODO match barrel order
    gameFinishService = GameFinishService(apiClient);
    gameLogService = GameLogService(apiClient);
    dlcService = DLCService(apiClient);
    dlcFinishService = DLCFinishService(apiClient);
    platformService = PlatformService(apiClient);
    tagService = TagService(apiClient);
  }

  static Future<void> testConnection(String host) {
    final ApiClient apiClient = ApiClient(basePath: host);
    final HealthCheckService healthCheckService = HealthCheckService(apiClient);
    return healthCheckService.isAlive();
  }
}
