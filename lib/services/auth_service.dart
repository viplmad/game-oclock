import 'dart:convert';

import 'package:game_oclock/models/models.dart' show SavedLoginResponse;

import 'shared_preferences_repository.dart';

class AuthService {
  AuthService(this.repository);

  final SharedPreferencesRepository repository;

  Future<SavedLoginResponse?> getCurrent() {
    return repository.get(
      _buildCurrentKey(),
      (final value) => SavedLoginResponse.fromJson(json.decode(value)),
    );
  }

  Future<void> saveCurrent(final SavedLoginResponse loginResponse) {
    return repository.set(
      _buildCurrentKey(),
      loginResponse,
      (final value) => json.encode(value.toJson()),
    );
  }

  Future<void> removeCurrent() {
    return repository.remove(_buildCurrentKey());
  }

  String _buildKey() => 'login';
  String _buildCurrentKey() => '${_buildKey()}#current';
}
