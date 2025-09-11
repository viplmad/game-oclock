import '../api_helper.dart';

class ErrorMessage {
  /// Returns a new [ErrorMessage] instance.
  ErrorMessage({required this.error, required this.errorDescription});

  String error;

  String errorDescription;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorMessage &&
          other.error == error &&
          other.errorDescription == errorDescription;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (error.hashCode) + (errorDescription.hashCode);

  @override
  String toString() =>
      'ErrorMessage[error=$error, errorDescription=$errorDescription]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'error'] = this.error;
    json[r'error_description'] = this.errorDescription;
    return json;
  }

  /// Returns a new [ErrorMessage] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ErrorMessage? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(
            json.containsKey(key),
            'Required key "ErrorMessage[$key]" is missing from JSON.',
          );
          assert(
            json[key] != null,
            'Required key "ErrorMessage[$key]" has a null value in JSON.',
          );
        });
        return true;
      }());

      return ErrorMessage(
        error: mapValueOfType<String>(json, r'error')!,
        errorDescription: mapValueOfType<String>(json, r'error_description')!,
      );
    }
    return null;
  }

  static List<ErrorMessage> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ErrorMessage>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ErrorMessage.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ErrorMessage> mapFromJson(dynamic json) {
    final map = <String, ErrorMessage>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ErrorMessage.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ErrorMessage-objects as value to a dart map
  static Map<String, List<ErrorMessage>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ErrorMessage>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ErrorMessage.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{'error', 'error_description'};
}
