import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:backend/connector/connector.dart' show CloudinaryConnector, CloudinaryInstance, ImageConnector, ItemConnector, PostgresConnector, PostgresInstance, ProviderInstance;

import 'package:backend/model/repository_type.dart';


class RepositoryPreferences {
  static const String _repositorySetKey = 'isRepositorySet';

  static const String _typeItemConnectorKey = 'itemConnectorType';
  static const String _typeImageConnectorKey = 'itemConnectorType';

  static const String _itemConnectionStringKey = 'itemConnectionString';
  static const String _imageConnectionStringKey = 'imageConnectionString';

  static const String _postgresItemConnectorValue = 'postgres';
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

  static Future<bool> setItemConnectorType(ItemConnectorType itemType) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    String value;
    switch(itemType) {
      case ItemConnectorType.Postgres:
        value = _postgresItemConnectorValue;
        break;
      case ItemConnectorType.Local:
        value = _localItemConnectorValue;
        break;
    }

    return sharedPreferences.setString(
      _typeItemConnectorKey,
      value,
    );

  }

  static Future<bool> setImageConnectorType(ImageConnectorType itemType) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    String value;
    switch(itemType) {
      case ImageConnectorType.Cloudinary:
        value = _cloudinaryImageConnectorValue;
        break;
      case ImageConnectorType.Local:
        value = _localImageConnectorValue;
        break;
    }

    return sharedPreferences.setString(
      _typeImageConnectorKey,
      value,
    );

  }

  static Future<bool> setItemInstance(ProviderInstance itemInstance) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    final String connectionString = itemInstance.connectionString();

    return sharedPreferences.setString(
      _itemConnectionStringKey,
      connectionString,
    );

  }

  static Future<bool> setImageInstance(ProviderInstance imageInstance) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    final String connectionString = imageInstance.connectionString();

    return sharedPreferences.setString(
      _imageConnectionStringKey,
      connectionString,
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

  static Future<ProviderInstance> retrieveItemInstance() async {

    final ItemConnectorType itemType = await retrieveItemConnectorType();

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_itemConnectionStringKey).then<ProviderInstance>((String value) {

      switch(itemType) {
        case ItemConnectorType.Postgres:
          return PostgresInstance.fromString(value);
        case ItemConnectorType.Local:
          throw Exception('Local type not supported');
      }

    }, onError: (Object error) => null);

  }

  static Future<ProviderInstance> retrieveImageInstance() async {

    final ImageConnectorType imageType = await retrieveImageConnectorType();

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_imageConnectionStringKey).then<ProviderInstance>((String value) {

      switch(imageType) {
        case ImageConnectorType.Cloudinary:
          return CloudinaryInstance.fromString(value);
        case ImageConnectorType.Local:
          throw Exception('Local type not supported');
      }

    }, onError: (Object error) => null);

  }

  static Future<ItemConnector> retrieveItemConnector() async {

    final ItemConnectorType itemType = await retrieveItemConnectorType();

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_itemConnectionStringKey).then<ItemConnector>((String value) {

      switch(itemType) {
        case ItemConnectorType.Postgres:
          return PostgresConnector.fromConnectionString(value);
        case ItemConnectorType.Local:
          throw Exception('Local type not supported');
      }

    }, onError: (Object error) => null);

  }

  static Future<ImageConnector> retrieveImageConnector() async {

    final ImageConnectorType imageType = await retrieveImageConnectorType();

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_imageConnectionStringKey).then<ImageConnector>((String value) {

      switch(imageType) {
        case ImageConnectorType.Cloudinary:
          return CloudinaryConnector.fromConnectionString(value);
        case ImageConnectorType.Local:
          throw Exception('Local type not supported');
      }

    }, onError: (Object error) => null);

  }
}