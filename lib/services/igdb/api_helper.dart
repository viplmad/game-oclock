import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
final _dateFormatter = DateFormat('yyyy-MM-dd');
final regList = RegExp(r'^List<(.*)>$');
final regSet = RegExp(r'^Set<(.*)>$');
final regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(final String? pattern) =>
    pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';

class QueryParam {
  const QueryParam(this.name, this.value);

  final String name;
  final String value;

  @override
  String toString() =>
      '${Uri.encodeQueryComponent(name)}=${Uri.encodeQueryComponent(value)}';
}

// Ported from the Java version.
Iterable<QueryParam> newQueryParams(
  String collectionFormat,
  final String name,
  final dynamic value,
) {
  // Assertions to run in debug mode only.
  assert(name.isNotEmpty, 'Parameter cannot be an empty string.');

  final params = <QueryParam>[];

  if (value is List) {
    if (collectionFormat == 'multi') {
      return value.map(
        (final dynamic v) => QueryParam(name, parameterToString(v)),
      );
    }

    // Default collection format is 'csv'.
    if (collectionFormat.isEmpty) {
      collectionFormat = 'csv'; // ignore: parameter_assignments
    }

    final delimiter = _delimiters[collectionFormat] ?? ',';

    params.add(
      QueryParam(name, value.map<dynamic>(parameterToString).join(delimiter)),
    );
  } else if (value != null) {
    params.add(QueryParam(name, parameterToString(value)));
  }

  return params;
}

/// Format the given parameter object into a [String].
String parameterToString(final dynamic value) {
  if (value == null) {
    return '';
  }
  if (value is DateTime) {
    return _dateFormatter.format(value);
  }
  if (value is Duration) {
    return value.toIso8601String();
  }
  return value.toString();
}

/// Returns the decoded body as UTF-8 if the given headers indicate an 'application/json'
/// content type. Otherwise, returns the decoded body as decoded by dart:http package.
Future<String> decodeBodyBytes(final Response response) async {
  final contentType = response.headers['content-type'];
  return contentType != null &&
          contentType.toLowerCase().startsWith('application/json')
      ? response.bodyBytes.isEmpty
            ? ''
            : utf8.decode(response.bodyBytes)
      : response.body;
}

/// Returns a valid [T] value found at the specified Map [key], null otherwise.
T? mapValueOfType<T>(final dynamic map, final String key) {
  final dynamic value = map is Map ? map[key] : null;
  return value is T ? value : null;
}

/// Returns a valid `Map<K, V>` found at the specified Map [key], null otherwise.
Map<K, V>? mapCastOfType<K, V>(final dynamic map, final String key) {
  final dynamic value = map is Map ? map[key] : null;
  return value is Map ? value.cast<K, V>() : null;
}

/// Returns a valid mappped `Map<K, V>` found at the specified Map [key], null otherwise.
Map<K, V>? mapMapOfType<K, V>(
  final dynamic map,
  final String key,
  final K Function(dynamic key) keyMapper,
  final V Function(dynamic val) valueMapper,
) {
  final dynamic value = map is Map ? map[key] : null;
  return value is Map
      ? value.map<K, V>((final dynamic k, final dynamic v) {
          final K mappedKey = keyMapper(k);
          final V mappedValue = valueMapper(v);
          return MapEntry(mappedKey, mappedValue);
        })
      : null;
}

/// Returns a valid [DateTime] found at the specified Map [key], null otherwise.
DateTime? mapDateTime(
  final dynamic map,
  final String key, [
  final String? pattern,
]) {
  final dynamic value = map is Map ? map[key] : null;
  if (value != null) {
    int? millis;
    if (value is int) {
      millis = value * 1000; // IGDB returns seconds since epoch
    } else if (value is String) {
      if (_isEpochMarker(pattern)) {
        millis = int.tryParse(value);
      } else {
        return DateTime.tryParse(value);
      }
    }
    if (millis != null) {
      return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
    }
  }
  return null;
}

Duration? mapDuration(final dynamic map, final String key) {
  final dynamic value = map is Map ? map[key] : null;
  if (value != null) {
    if (value is String) {
      return DurationExtension.tryParse(value);
    }
  }
  return null;
}

extension DurationExtension on Duration {
  String toIso8601String() {
    final d = inDays.toInt();
    final h = (inHours % Duration.hoursPerDay).toInt();
    final min = (inMinutes % Duration.minutesPerHour).toInt();
    final sec = (inSeconds % Duration.secondsPerMinute);
    return 'P${d}DT${h}H${min}M${sec}S';
  }

  static Duration? tryParse(final String formattedString) {
    try {
      return parse(formattedString);
    } on FormatException {
      return null;
    }
  }

  static final RegExp _parseFormat = RegExp(
    r'^(-|\+)?P(?:([-+]?[0-9,.]*)Y)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)W)?(?:([-+]?[0-9,.]*)D)?(?:T(?:([-+]?[0-9,.]*)H)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)S)?)?$',
  );

  static Duration parse(final String formattedString) {
    final re = _parseFormat;
    final Match? match = re.firstMatch(formattedString);
    if (match != null) {
      final day = _parseTime(formattedString, 'D');
      final hour = _parseTime(formattedString, 'H');
      final minute = _parseTime(formattedString, 'M');
      final second = _parseTime(formattedString, 'S');

      return Duration(days: day, hours: hour, minutes: minute, seconds: second);
    } else {
      throw FormatException('Invalid duration format', formattedString);
    }
  }

  /// Private helper method for extracting a time value from the ISO8601 string.
  static int _parseTime(final String duration, final String timeUnit) {
    final timeMatch = RegExp(r'\d+' + timeUnit).firstMatch(duration);

    if (timeMatch == null) {
      return 0;
    }
    final String timeString = timeMatch.group(0)!;
    return int.parse(timeString.substring(0, timeString.length - 1));
  }
}
