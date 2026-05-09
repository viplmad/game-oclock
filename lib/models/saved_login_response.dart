import 'package:game_oclock_client/api.dart';

class SavedLoginResponse {
  final String host;
  final String username;
  final TokenResponse tokenResponse;

  const SavedLoginResponse({
    required this.host,
    required this.username,
    required this.tokenResponse,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'host'] = host;
    json[r'username'] = username;
    json[r'tokenResponse'] = tokenResponse.toJson();
    return json;
  }

  static SavedLoginResponse fromJson(final dynamic value) {
    final json = value.cast<String, dynamic>();

    return SavedLoginResponse(
      host: json[r'host']!,
      username: json[r'username']!,
      tokenResponse: TokenResponse.fromJson(json[r'tokenResponse'])!,
    );
  }
}
