import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show SavedLoginResponse;

class AuthService {
  Future<SavedLoginResponse> getSavedLoginResponse() async {
    return mockSavedLoginResponse();
  }

  Future<void> saveLoginResponse(final SavedLoginResponse loginResponse) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
