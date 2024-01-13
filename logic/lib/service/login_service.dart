import 'package:game_oclock_client/api.dart'
    show ApiClient, AuthApi, GrantType, TokenResponse;

class LoginService {
  LoginService(ApiClient apiClient) {
    _api = AuthApi(apiClient);
  }

  late final AuthApi _api;

  Future<TokenResponse> login(String username, String password) {
    return _api.token(
      GrantType.password,
      username: username,
      password: password,
    );
  }

  Future<TokenResponse> refreshToken(String refreshToken) {
    return _api.token(GrantType.refreshToken, refreshToken: refreshToken);
  }
}
