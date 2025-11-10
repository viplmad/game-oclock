import 'package:game_oclock/models/models.dart'
    show GameOClockException, errorCodeNotFound;
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  Future<String> getString(final String key) =>
      get(key, (final value) => value);

  Future<void> setString(final String key, final String value) =>
      set(key, value, (final value) => value);

  Future<T> get<T>(final String key, final T Function(String value) map) =>
      asyncPrefs.getString(key).then((final value) {
        if (value == null) {
          throw GameOClockException(
            code: errorCodeNotFound,
            message: 'SharedPrefs value with key $key not found',
          );
        }
        return map(value);
      });

  Future<void> set<T>(
    final String key,
    final T data,
    final String Function(T value) map,
  ) => asyncPrefs.setString(key, map(data));

  Future<void> remove(final String key) => asyncPrefs.remove(key);

  Future<bool> exists(final String key) => asyncPrefs.containsKey(key);
}
