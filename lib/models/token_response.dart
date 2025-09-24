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
}
