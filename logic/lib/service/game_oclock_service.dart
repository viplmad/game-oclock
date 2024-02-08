import 'package:game_oclock_client/api.dart'
    show ApiClient, OAuth, TokenResponse;

import 'service.dart';

class GameOClockService {
  GameOClockService();

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

  Future<TokenResponse> refresh(
    String host,
    String refreshToken,
  ) {
    final ApiClient apiClient = ApiClient(basePath: host);
    final LoginService loginService = LoginService(apiClient);
    return loginService.refreshToken(refreshToken);
  }

  void init(
    String host,
    TokenResponse tokenResponse, {
    required Future<void> Function(TokenResponse) onTokenRefresh,
  }) {
    final ApiClient apiClient = ApiClient(
      basePath: host,
      authentication: OAuth(
        accessToken: tokenResponse.accessToken,
        refreshToken: tokenResponse.refreshToken,
        refresh: (String refreshToken) async {
          final TokenResponse tokenResponse = await refresh(host, refreshToken);

          await onTokenRefresh(tokenResponse);

          // Set connection with new token
          return (tokenResponse.accessToken, tokenResponse.refreshToken);
        },
      ),
    );

    _init(apiClient);
  }

  void _init(ApiClient apiClient) {
    userService = UserService(apiClient);
    gameService = GameService(apiClient);
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
    return healthCheckService.health();
  }
}
