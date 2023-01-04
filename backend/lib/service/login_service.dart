import 'package:game_collection_client/api.dart'
    show ApiClient, AuthApi, GrantType, TokenResponse;

class LoginService {
  LoginService(ApiClient apiClient) {
    api = AuthApi(apiClient);
  }

  late final AuthApi api;

  Future<TokenResponse> login(String username, String password) {
    return api.token(GrantType.password, username: username, password: password)
        as Future<TokenResponse>;
  }

  Future<TokenResponse> refreshToken(String refreshToken) {
    return api.token(GrantType.refreshToken, refreshToken: refreshToken)
        as Future<TokenResponse>;
  }
}
