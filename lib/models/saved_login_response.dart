import 'models.dart' show TokenResponse;

class SavedLoginResponse {
  final String host;
  final String username;
  final TokenResponse tokenResponse;

  const SavedLoginResponse({
    required this.host,
    required this.username,
    required this.tokenResponse,
  });
}
