import 'package:game_oclock_client/api.dart';

class LoginService {
  final AuthApi _api;

  LoginService(ApiClient apiClient) : _api = AuthApi(apiClient);

  Future<TokenResponse> login(String username, String password) async {
    return _api.token(
      GrantType.password,
      username: username,
      password: password,
    );
  }

  Future<TokenResponse> refresh(String refreshToken) async {
    return _api.token(GrantType.refreshToken, refreshToken: refreshToken);
  }
}
