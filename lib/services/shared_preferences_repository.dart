import 'package:game_oclock/models/models.dart'
    show GameOClockException, errorCodeNotFound;
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  Future<String> getString(String key) => get(key, (value) => value);

  Future<void> setString(String key, String value) =>
      set(key, value, (value) => value);

  Future<T> get<T>(String key, T Function(String value) map) =>
      asyncPrefs.getString(key).then((value) {
        if (value == null) {
          throw GameOClockException(
            code: errorCodeNotFound,
            message: 'SharedPrefs value with key $key not found',
          );
        }
        return map(value);
      });

  Future<void> set<T>(String key, T data, String Function(T value) map) =>
      asyncPrefs.setString(key, map(data));

  Future<void> remove(String key) => asyncPrefs.remove(key);

  Future<bool> exists(String key) => asyncPrefs.containsKey(key);
}
