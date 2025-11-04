import 'package:game_oclock/models/models.dart' show ListStyle, parseListStyle;
import 'package:shared_preferences/shared_preferences.dart';

class ListStyleService {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  Future<ListStyle?> get(final String space) async {
    return asyncPrefs
        .getString(_buildKey(space))
        .then((final value) => value == null ? null : parseListStyle(value));
  }

  Future<void> save(final String space, final ListStyle style) {
    return asyncPrefs.setString(_buildKey(space), style.name);
  }

  String _buildKey(final String space) => 'list-style#$space';
}
