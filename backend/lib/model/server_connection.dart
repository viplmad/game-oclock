import 'package:game_collection_client/api.dart'
    show TokenResponse, mapValueOfType;

class ServerConnection {
  ServerConnection({
    required this.name,
    required this.host,
    required this.username,
    required this.tokenResponse,
  });

  final String name;
  final String host;
  final String username;
  final TokenResponse tokenResponse;

  ServerConnection withToken(TokenResponse tokenResponse) {
    return ServerConnection(
      name: name,
      host: host,
      username: username,
      tokenResponse: tokenResponse,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json[r'name'] = name;
    json[r'host'] = host;
    json[r'username'] = username;
    json[r'token_response'] = tokenResponse.toJson();
    return json;
  }

  /// Returns a new [ServerConnection] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  static ServerConnection? fromJson(dynamic value) {
    if (value is Map) {
      final Map<String, dynamic> json = value.cast<String, dynamic>();

      return ServerConnection(
        name: mapValueOfType<String>(json, r'name')!,
        host: mapValueOfType<String>(json, r'host')!,
        username: mapValueOfType<String>(json, r'username')!,
        tokenResponse: TokenResponse.fromJson(json[r'token_response'])!,
      );
    }
    return null;
  }
}
