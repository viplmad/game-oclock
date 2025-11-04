import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  Future<T?> get<T>(
    final String key,
    final T Function(String value) map,
  ) async {
    return asyncPrefs
        .getString(key)
        .then((final value) => value == null ? null : map(value));
  }

  Future<void> set<T>(
    final String key,
    final T data,
    final String Function(T value) map,
  ) {
    return asyncPrefs.setString(key, map(data));
  }

  Future<void> remove(final String key) {
    return asyncPrefs.remove(key);
  }
}
