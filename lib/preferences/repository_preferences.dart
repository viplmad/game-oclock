import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:game_collection/connector/image/cloudinary/cloudinary_connector.dart';
import 'package:game_collection/connector/item/sql/postgres/postgres_connector.dart';

import 'package:game_collection/model/repository_type.dart';

import 'package:game_collection/repository/icollection_repository.dart';
import 'package:game_collection/repository/remote_repository.dart';
import 'package:game_collection/repository/local_repository.dart';


const String _repositorySetKey = 'isRepositorySet';
const String _typeRepositoryKey = 'repositoryType';
const String _postgresConnectionStringKey = 'postgresConnectionString';
const String _cloudinaryConnectionStringKey = 'cloudinaryConnectionString';

const String _remoteRepositoryValue = 'remote';
const String _localRepositoryValue = 'local';

const String _trueValue = '1';
const String _falseValue = '0';

class RepositoryPreferences {

  static Future<bool> existsRepository(){

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_repositorySetKey).then<bool>((String value) {

      return value == _trueValue;

    });

  }

  static Future<RepositoryType> retrieveRepositoryType() {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_typeRepositoryKey).then<RepositoryType>((String value) {

      switch(value) {
        case _remoteRepositoryValue:
          return RepositoryType.Remote;
        case _localRepositoryValue:
          return RepositoryType.Local;
      }

    });

  }

  static Future<ICollectionRepository> retrieveRepository() {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_typeRepositoryKey).then<ICollectionRepository>((String value) {
      if(value == _remoteRepositoryValue) {

        return _retrieveRemoteRepository(sharedPreferences);


      }/* else if(value == _localRepositoryValue) {

        return retrieveAndSetLocalRepositoryData(sharedPreferences);

      }*/

      return null;

    }, onError: (error) => null);

  }

  static Future<bool> setRepositoryExist() {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.setString(
      _repositorySetKey,
      _trueValue,
    );

  }

  static Future<bool> setRepositoryTypeRemote() {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.setString(
      _typeRepositoryKey,
      _remoteRepositoryValue,
    );

  }

  static Future<bool> setRepositoryTypeLocal() {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.setString(
      _typeRepositoryKey,
      _localRepositoryValue,
    );

  }

  static Future<CloudinaryInstance> retrieveCloudinaryInstance() {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_cloudinaryConnectionStringKey).then<CloudinaryInstance>((String value) {

      CloudinaryInstance cloudinaryInstance;
      if(value != null && value.isNotEmpty) {
        cloudinaryInstance = CloudinaryInstance.fromString(value);
      }

      return cloudinaryInstance;

    }, onError: (error) => null);

  }

  static Future<PostgresInstance> retrievePostgresInstance() {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_postgresConnectionStringKey).then<PostgresInstance>((String value) {

      PostgresInstance postgresInstance;
      if(value != null && value.isNotEmpty) {
        postgresInstance = PostgresInstance.fromString(value);
      }

      return postgresInstance;

    }, onError: (error) => null);

  }

  static Future<bool> setCloudinaryConnector(CloudinaryInstance cloudinaryInstance) {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    String connectionString = cloudinaryInstance.connectionString();

    return sharedPreferences.setString(
      _cloudinaryConnectionStringKey,
      connectionString,
    );

  }

  static Future<bool> setPostgresConnector(PostgresInstance postgresInstance) {

    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    String connectionString = postgresInstance.connectionString();

    return sharedPreferences.setString(
      _postgresConnectionStringKey,
      connectionString,
    );

  }

  static Future<RemoteRepository> _retrieveRemoteRepository(EncryptedSharedPreferences sharedPreferences) async {

    return RemoteRepository(
      iSQLConnector: await _retrievePostgresConnector(sharedPreferences),
      iImageConnector: await _retrieveCloudinaryConnector(sharedPreferences),
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

    }, onError: (error) => null);

  }

  static Future<PostgresConnector> _retrievePostgresConnector(EncryptedSharedPreferences sharedPreferences) {

    return sharedPreferences.getString(_postgresConnectionStringKey).then<PostgresConnector>((String value) {

      return PostgresConnector.fromConnectionString(value);

    }, onError: (error) => null);

  }
}