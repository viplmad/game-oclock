import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:backend/connector/connector.dart';

import 'package:backend/model/repository_type.dart';

import 'package:backend/repository/repository.dart';


const String _repositorySetKey = 'isRepositorySet';
const String _typeRepositoryKey = 'repositoryType';
const String _postgresConnectionStringKey = 'postgresConnectionString';
const String _cloudinaryConnectionStringKey = 'cloudinaryConnectionString';

const String _remoteRepositoryValue = 'remote';
const String _localRepositoryValue = 'local';

const String _trueValue = '1';

class RepositoryPreferences {
  static Future<bool> existsRepository(){

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_repositorySetKey).then<bool>((String value) {

      return value == _trueValue;

    }, onError: (Object error) => false);

  }

  static Future<RepositoryType> retrieveRepositoryType() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_typeRepositoryKey).then<RepositoryType>((String value) {

      switch(value) {
        case _remoteRepositoryValue:
          return RepositoryType.Remote;
        case _localRepositoryValue:
          return RepositoryType.Local;
      }

      throw const FormatException();

    }, onError: (Object error) => null);

  }

  static Future<CollectionRepository> retrieveRepository() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return retrieveRepositoryType().then<CollectionRepository>((RepositoryType type) {

      switch(type) {
        case RepositoryType.Remote:
          return _retrieveRemoteRepository(sharedPreferences);
        case RepositoryType.Local:
          //return _retrieveLocalRepository(sharedPreferences);
          break;
      }

      throw const FormatException();

    }, onError: (Object error) => null);

  }

  static Future<bool> setRepositoryExist() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.setString(
      _repositorySetKey,
      _trueValue,
    );

  }

  static Future<bool> setRepositoryTypeRemote() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.setString(
      _typeRepositoryKey,
      _remoteRepositoryValue,
    );

  }

  static Future<bool> setRepositoryTypeLocal() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.setString(
      _typeRepositoryKey,
      _localRepositoryValue,
    );

  }

  static Future<CloudinaryInstance> retrieveCloudinaryInstance() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_cloudinaryConnectionStringKey).then<CloudinaryInstance>((String value) {

      if(value.isNotEmpty) {
        return CloudinaryInstance.fromString(value);
      }

      throw const FormatException();

    }, onError: (Object error) => null);

  }

  static Future<PostgresInstance> retrievePostgresInstance() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_postgresConnectionStringKey).then<PostgresInstance>((String value) {

      if(value.isNotEmpty) {
        return PostgresInstance.fromString(value);
      }

      throw const FormatException();

    }, onError: (Object error) => null);

  }

  static Future<bool> setCloudinaryConnector(CloudinaryInstance cloudinaryInstance) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    final String connectionString = cloudinaryInstance.connectionString();

    return sharedPreferences.setString(
      _cloudinaryConnectionStringKey,
      connectionString,
    );

  }

  static Future<bool> setPostgresConnector(PostgresInstance postgresInstance) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    final String connectionString = postgresInstance.connectionString();

    return sharedPreferences.setString(
      _postgresConnectionStringKey,
      connectionString,
    );

  }

  static Future<RemoteRepository> _retrieveRemoteRepository(EncryptedSharedPreferences sharedPreferences) async {

    return RemoteRepository(
      await _retrievePostgresConnector(sharedPreferences),
      await _retrieveCloudinaryConnector(sharedPreferences),
    );

  }

  /*static Future<LocalRepository> _retrieveLocalRepository(EncryptedSharedPreferences sharedPreferences) async {

    return LocalRepository(
      iFileConnector: await
      iImageConnector: await retrieveAndSetCloudinaryConnector(sharedPreferences),
    );

  }*/

  static Future<CloudinaryConnector> _retrieveCloudinaryConnector(EncryptedSharedPreferences sharedPreferences) {

    return sharedPreferences.getString(_cloudinaryConnectionStringKey).then<CloudinaryConnector>((String value) {

      return CloudinaryConnector.fromConnectionString(value);

    }, onError: (Object error) => null);

  }

  static Future<PostgresConnector> _retrievePostgresConnector(EncryptedSharedPreferences sharedPreferences) {

    return sharedPreferences.getString(_postgresConnectionStringKey).then<PostgresConnector>((String value) {

      return PostgresConnector.fromConnectionString(value);

    }, onError: (Object error) => null);

  }
}