import 'package:game_oclock/models/models.dart'
    show ListStyle, listStyleToString, parseListStyle;

import 'shared_preferences_repository.dart';

class ListStyleService {
  const ListStyleService(this.repository);

  final SharedPreferencesRepository repository;

  Future<ListStyle?> getCurrent(final String space) {
    return repository.get(
      _buildCurrentKey(space),
      (final value) => parseListStyle(value),
    );
  }

  Future<void> saveCurrent(final String space, final ListStyle style) {
    return repository.set(
      _buildCurrentKey(space),
      style,
      (final value) => listStyleToString(value),
    );
  }

  Future<void> removeCurrent(final String space) {
    return repository.remove(_buildCurrentKey(space));
  }

  String _buildKey(final String space) => 'list-style#$space';
  String _buildCurrentKey(final String space) => '${_buildKey(space)}#current';
}
