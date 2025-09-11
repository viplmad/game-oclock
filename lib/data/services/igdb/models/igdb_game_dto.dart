import '../api_helper.dart';

class IGDBCover {
  IGDBCover({required this.id, required this.url});

  int id;
  String url;

  /// Returns a new [IGDBCover] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IGDBCover? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(
            json.containsKey(key),
            'Required key "Element[$key]" is missing from JSON.',
          );
          assert(
            json[key] != null,
            'Required key "Element[$key]" has a null value in JSON.',
          );
        });
        return true;
      }());

      return IGDBCover(
        id: mapValueOfType<int>(json, r'id')!,
        url: mapValueOfType<String>(json, r'url')!,
      );
    }
    return null;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{'id', 'url'};
}

class IGDBIdName {
  IGDBIdName({required this.id, required this.name});

  int id;
  String name;

  /// Returns a new [IGDBIdName] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IGDBIdName? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(
            json.containsKey(key),
            'Required key "IGDBIdName[$key]" is missing from JSON.',
          );
          assert(
            json[key] != null,
            'Required key "IGDBIdName[$key]" has a null value in JSON.',
          );
        });
        return true;
      }());

      return IGDBIdName(
        id: mapValueOfType<int>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<IGDBIdName> listFromJson(dynamic json, {bool growable = false}) {
    final result = <IGDBIdName>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IGDBIdName.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{'id', 'name'};
}

class IGDBGame {
  /// Returns a new [IGDBGame] instance.
  IGDBGame({
    required this.id,
    required this.name,
    required this.cover,
    required this.firstReleaseDate,
    required this.genres,
    required this.collections,
  });

  int id;

  String name;

  IGDBCover? cover;

  DateTime? firstReleaseDate;

  List<IGDBIdName> genres;

  List<IGDBIdName> collections;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IGDBGame &&
          other.name == name &&
          other.cover == cover &&
          other.firstReleaseDate == firstReleaseDate &&
          other.genres == genres &&
          other.collections == collections;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (name.hashCode) +
      (cover == null ? 0 : cover.hashCode) +
      (firstReleaseDate == null ? 0 : firstReleaseDate.hashCode) +
      (genres.hashCode) +
      (collections.hashCode);

  /// Returns a new [IGDBGame] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IGDBGame? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(
            json.containsKey(key),
            'Required key "IGDBGameDTO[$key]" is missing from JSON.',
          );
          assert(
            json[key] != null,
            'Required key "IGDBGameDTO[$key]" has a null value in JSON.',
          );
        });
        return true;
      }());

      return IGDBGame(
        id: mapValueOfType<int>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        cover: IGDBCover.fromJson(json[r'cover']),
        firstReleaseDate: mapDateTime(json, r'first_release_date', r''),
        genres: IGDBIdName.listFromJson(json[r'genres']),
        collections: IGDBIdName.listFromJson(json[r'collections']),
      );
    }
    return null;
  }

  static List<IGDBGame> listFromJson(dynamic json, {bool growable = false}) {
    final result = <IGDBGame>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IGDBGame.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{'id', 'name'};
}
