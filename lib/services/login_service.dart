import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show TokenResponse;

class LoginService {
  Future<TokenResponse> login(
    final String host,
    final String username,
    final String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockTokenResponse();
  }
}
