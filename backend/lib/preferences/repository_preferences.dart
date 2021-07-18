import 'package:backend/model/repository_type.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:backend/connector/connector.dart';


class RepositoryPreferences {
  static const String _repositorySetKey = 'isRepositorySet';

  static const String _typeItemConnectorKey = 'itemConnectorType';
  static const String _typeImageConnectorKey = 'itemConnectorType';

  static const String _postgresConnectionStringKey = 'postgresConnectionString';
  static const String _cloudinaryConnectionStringKey = 'cloudinaryConnectionString';

  static const String _postgresItemConnectorValue = 'posgres';
  static const String _localItemConnectorValue = 'local';

  static const String _cloudinaryImageConnectorValue = 'cloudinary';
  static const String _localImageConnectorValue = 'local';

  static const String _trueValue = '1';

  static Future<bool> existsRepository(){

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_repositorySetKey).then<bool>((String value) {

      return value == _trueValue;

    }, onError: (Object error) => false);

  }

  static Future<bool> setRepositoryExist() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.setString(
      _repositorySetKey,
      _trueValue,
    );

  }

  static Future<bool> setPostgresConnector(PostgresInstance postgresInstance) async {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    final String connectionString = postgresInstance.connectionString();

    await sharedPreferences.setString(
      _postgresConnectionStringKey,
      connectionString,
    );

    return sharedPreferences.setString(
      _typeItemConnectorKey,
      _postgresItemConnectorValue,
    );

  }

  static Future<bool> setCloudinaryConnector(CloudinaryInstance cloudinaryInstance) async {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    final String connectionString = cloudinaryInstance.connectionString();

    await sharedPreferences.setString(
      _cloudinaryConnectionStringKey,
      connectionString,
    );

    return sharedPreferences.setString(
      _typeImageConnectorKey,
      _cloudinaryImageConnectorValue,
    );

  }

  static Future<ItemConnectorType> retrieveItemConnectorType() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_typeItemConnectorKey).then<ItemConnectorType>((String value) {

      switch(value) {
        case _postgresItemConnectorValue:
          return ItemConnectorType.Postgres;
        case _localItemConnectorValue:
          return ItemConnectorType.Local;
      }

      throw const FormatException();

    }, onError: (Object error) => null);

  }

  static Future<ImageConnectorType> retrieveImageConnectorType() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_typeImageConnectorKey).then<ImageConnectorType>((String value) {

      switch(value) {
        case _cloudinaryImageConnectorValue:
          return ImageConnectorType.Cloudinary;
        case _localImageConnectorValue:
          return ImageConnectorType.Local;
      }

      throw const FormatException();

    }, onError: (Object error) => null);

  }

  static Future<ItemConnector> retrieveItemConnector() async {

    final ItemConnectorType itemType = await retrieveItemConnectorType();

    switch(itemType) {
      case ItemConnectorType.Postgres:
        return _retrievePostgresConnector();
      case ItemConnectorType.Local:
        return Future<ItemConnector>.error('Local type not supported');
    }

  }

  static Future<ImageConnector> retrieveImageConnector() async {

    final ImageConnectorType imageType = await retrieveImageConnectorType();

    switch(imageType) {
      case ImageConnectorType.Cloudinary:
        return _retrieveCloudinaryConnector();
      case ImageConnectorType.Local:
        return Future<ImageConnector>.error('Local type not supported');
    }

  }

  static Future<PostgresConnector> _retrievePostgresConnector() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_postgresConnectionStringKey).then<PostgresConnector>((String value) {

      return PostgresConnector.fromConnectionString(value);

    }, onError: (Object error) => null);

  }

  static Future<CloudinaryConnector> _retrieveCloudinaryConnector() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_cloudinaryConnectionStringKey).then<CloudinaryConnector>((String value) {

      return CloudinaryConnector.fromConnectionString(value);

    }, onError: (Object error) => null);

  }
}