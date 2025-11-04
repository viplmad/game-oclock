import 'package:game_oclock/models/models.dart' show ListStyle, parseListStyle;

import 'shared_preferences_repository.dart';

class ListStyleService {
  const ListStyleService(this.repository);

  final SharedPreferencesRepository repository;

  Future<ListStyle?> get(final String space) async {
    return repository.get(
      _buildKey(space),
      (final value) => parseListStyle(value),
    );
  }

  Future<void> save(final String space, final ListStyle style) {
    return repository.set(_buildKey(space), style, (final value) => value.name);
  }

  String _buildKey(final String space) => 'list-style#$space';
}
