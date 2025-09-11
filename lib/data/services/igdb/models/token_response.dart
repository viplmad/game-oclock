import '../api_helper.dart';

class TokenResponse {
  /// Returns a new [TokenResponse] instance.
  TokenResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
  });

  String accessToken;

  int expiresIn;

  String tokenType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenResponse &&
          other.accessToken == accessToken &&
          other.expiresIn == expiresIn &&
          other.tokenType == tokenType;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (accessToken.hashCode) + (expiresIn.hashCode) + (tokenType.hashCode);

  @override
  String toString() =>
      'TokenResponse[accessToken=$accessToken, expiresIn=$expiresIn, tokenType=$tokenType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'access_token'] = this.accessToken;
    json[r'expires_in'] = this.expiresIn;
    json[r'token_type'] = this.tokenType;
    return json;
  }

  /// Returns a new [TokenResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TokenResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(
            json.containsKey(key),
            'Required key "TokenResponse[$key]" is missing from JSON.',
          );
          assert(
            json[key] != null,
            'Required key "TokenResponse[$key]" has a null value in JSON.',
          );
        });
        return true;
      }());

      return TokenResponse(
        accessToken: mapValueOfType<String>(json, r'access_token')!,
        expiresIn: mapValueOfType<int>(json, r'expires_in')!,
        tokenType: mapValueOfType<String>(json, r'token_type')!,
      );
    }
    return null;
  }

  static List<TokenResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <TokenResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TokenResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TokenResponse> mapFromJson(dynamic json) {
    final map = <String, TokenResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TokenResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TokenResponse-objects as value to a dart map
  static Map<String, List<TokenResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<TokenResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TokenResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_token',
    'expires_in',
    'token_type',
  };
}
