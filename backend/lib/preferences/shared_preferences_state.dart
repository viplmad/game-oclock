import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:backend/model/model.dart' show ServerConnection;

class SharedPreferencesState {
  const SharedPreferencesState._();

  static const String _serverKey = 'server';
  static const String _totalServersKey = 'totalServers';
  static const String _activeServerIndexKey = 'activeServer';

  // Initial game view
  static const String _startGameViewIndexKey = 'startGameViewIndex';

  static Future<bool> existsActiveServer() async {
    return await retrieveActiveServerIndex() != null;
  }

  //#region SET
  static Future<bool> setActiveServer(
    ServerConnection server,
  ) async {
    final EncryptedSharedPreferences sharedPreferences =
        EncryptedSharedPreferences();

    final String serverString = json.encode(server.toJson());

    const int activeServerIndex = 0;
    return sharedPreferences
        .setString(
      _activeServerIndexKey,
      activeServerIndex.toString(),
    )
        .then<bool>((bool success) {
      if (success) {
        return sharedPreferences.setString(
          _buildServerKey(activeServerIndex),
          serverString,
        );
      }

      return false;
    });
  }

  static Future<bool> setStartGameViewIndex(
    int? gameViewIndex,
  ) {
    final EncryptedSharedPreferences sharedPreferences =
        EncryptedSharedPreferences();

    if (gameViewIndex != null && gameViewIndex >= 0) {
      final String viewIndexString = gameViewIndex.toString();

      return sharedPreferences.setString(
        _startGameViewIndexKey,
        viewIndexString,
      );
    }

    return Future<bool>.value(false);
  }
  //#endregion SET

  //#region RETRIEVE
  static Future<int?> retrieveActiveServerIndex() {
    final EncryptedSharedPreferences sharedPreferences =
        EncryptedSharedPreferences();

    return sharedPreferences.getString(_activeServerIndexKey).then<int?>(
      (String value) {
        return int.tryParse(value); // TODO Log error
      },
      onError: (Object error) => null,
    );
  }

  static Future<int?> retrieveTotalServers() {
    final EncryptedSharedPreferences sharedPreferences =
        EncryptedSharedPreferences();

    return sharedPreferences.getString(_totalServersKey).then<int?>(
      (String value) {
        return int.tryParse(value); // TODO Log error
      },
      onError: (Object error) => null,
    );
  }

  static Future<ServerConnection?> retrieveActiveServer() async {
    final int? activeServerIndex = await retrieveActiveServerIndex();

    final EncryptedSharedPreferences sharedPreferences =
        EncryptedSharedPreferences();

    if (activeServerIndex == null) {
      return Future<ServerConnection?>.value(null);
    }

    return sharedPreferences
        .getString(_buildServerKey(activeServerIndex))
        .then<ServerConnection?>(
      (String value) {
        return ServerConnection.fromJson(jsonDecode(value));
      },
      onError: (Object error) => null,
    );
  }

  static Future<int?> retrieveInitialGameViewIndex() async {
    final EncryptedSharedPreferences sharedPreferences =
        EncryptedSharedPreferences();

    return sharedPreferences.getString(_startGameViewIndexKey).then<int?>(
      (String value) {
        return int.tryParse(value);
      },
      onError: (Object error) => null,
    );
  }
  //#endregion RETRIEVE

  static String _buildServerKey(int activeServerIndex) {
    return '$_serverKey$activeServerIndex';
  }
}
