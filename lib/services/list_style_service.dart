import 'package:game_oclock/models/models.dart'
    show ListStyle, listStyleToString, parseListStyle;

import 'shared_preferences_repository.dart';

class ListStyleService {
  const ListStyleService(this.repository);

  final SharedPreferencesRepository repository;

  Future<ListStyle> getCurrent(String space) {
    return repository.get(
      _buildCurrentKey(space),
      (value) => parseListStyle(value),
    );
  }

  Future<void> saveCurrent(String space, ListStyle style) {
    return repository.set(
      _buildCurrentKey(space),
      style,
      (value) => listStyleToString(value),
    );
  }

  Future<void> removeCurrent(String space) {
    return repository.remove(_buildCurrentKey(space));
  }

  String _buildKey(String space) => 'list-style#$space';
  String _buildCurrentKey(String space) => '${_buildKey(space)}#current';
}
