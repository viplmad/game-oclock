class TokenResponse {
  /// Returns a new [TokenResponse] instance.
  TokenResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
    required this.tokenType,
  });

  String accessToken;

  int expiresIn;

  String refreshToken;

  String tokenType;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'access_token'] = accessToken;
    json[r'expires_in'] = expiresIn;
    json[r'refresh_token'] = refreshToken;
    json[r'token_type'] = tokenType;
    return json;
  }

  static TokenResponse fromJson(final dynamic value) {
    final json = value.cast<String, dynamic>();

    return TokenResponse(
      accessToken: json[r'access_token']!,
      expiresIn: json[r'expires_in']!,
      refreshToken: json[r'refresh_token']!,
      tokenType: json[r'token_type']!,
    );
  }
}
