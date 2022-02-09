import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:backend/connector/connector.dart' show CloudinaryConnector, CloudinaryInstance, ImageConnector, ItemConnector, PostgresConnector, PostgresInstance, ProviderInstance;

import 'package:backend/model/repository_type.dart';


class RepositoryPreferences {
  const RepositoryPreferences._();

  static const String _errorLocalTypeNotSupported = 'Local type not supported';

  static const String _typeItemConnectorKey = 'itemConnectorType';
  static const String _typeImageConnectorKey = 'imageConnectorType';

  static const String _itemConnectionStringKey = 'itemConnectionString';
  static const String _imageConnectionStringKey = 'imageConnectionString';

  static const String _postgresItemConnectorValue = 'postgres';
  static const String _localItemConnectorValue = 'local';

  static const String _cloudinaryImageConnectorValue = 'cloudinary';
  static const String _localImageConnectorValue = 'local';

  static const String _emptyValue = 'empty';

  static Future<bool> existsItemConnection() async {

    return await retrieveActiveItemConnectorType() != null;

  }

  //#region SET
  static Future<bool> setActiveItemConnectorType(ItemConnectorType? itemType) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    String value;
    switch(itemType) {
      case ItemConnectorType.postgres:
        value = _postgresItemConnectorValue;
        break;
      case ItemConnectorType.local:
        value = _localItemConnectorValue;
        break;
      default:
        value = _emptyValue;
    }

    return sharedPreferences.setString(
      _typeItemConnectorKey,
      value,
    );

  }

  static Future<bool> setActiveImageConnectorType(ImageConnectorType? imageType) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    String value;
    switch(imageType) {
      case ImageConnectorType.cloudinary:
        value = _cloudinaryImageConnectorValue;
        break;
      case ImageConnectorType.local:
        value = _localImageConnectorValue;
        break;
      default:
        value = _emptyValue;
    }

    return sharedPreferences.setString(
      _typeImageConnectorKey,
      value,
    );

  }

  static Future<bool> setActiveItemInstance(ProviderInstance? itemInstance) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    String connectionString = _emptyValue;
    if(itemInstance != null) {
      connectionString = itemInstance.connectionString();
    }

    return sharedPreferences.setString(
      _itemConnectionStringKey,
      connectionString,
    );

  }

  static Future<bool> setActiveImageInstance(ProviderInstance? imageInstance) {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    String connectionString = _emptyValue;
    if(imageInstance != null) {
      connectionString = imageInstance.connectionString();
    }

    return sharedPreferences.setString(
      _imageConnectionStringKey,
      connectionString,
    );

  }
  //#endregion SET

  //#region RETRIEVE
  static Future<ItemConnectorType?> retrieveActiveItemConnectorType() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_typeItemConnectorKey).then<ItemConnectorType?>((String value) {

      switch(value) {
        case _postgresItemConnectorValue:
          return ItemConnectorType.postgres;
        case _localItemConnectorValue:
          return ItemConnectorType.local;
        default:
          return null;
      }

    }, onError: (Object error) => null);

  }

  static Future<ImageConnectorType?> retrieveActiveImageConnectorType() {

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_typeImageConnectorKey).then<ImageConnectorType?>((String value) {

      switch(value) {
        case _cloudinaryImageConnectorValue:
          return ImageConnectorType.cloudinary;
        case _localImageConnectorValue:
          return ImageConnectorType.local;
        default:
          return null;
      }

    }, onError: (Object error) => null);

  }

  static Future<ProviderInstance?> retrieveActiveItemInstance() async {

    final ItemConnectorType? itemType = await retrieveActiveItemConnectorType();

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_itemConnectionStringKey).then<ProviderInstance?>((String value) {

      switch(itemType!) {
        case ItemConnectorType.postgres:
          return PostgresInstance.fromString(value);
        case ItemConnectorType.local:
          throw Exception(_errorLocalTypeNotSupported);
        default:
          return null;
      }

    }, onError: (Object error) => null);

  }

  static Future<ProviderInstance?> retrieveActiveImageInstance() async {

    final ImageConnectorType? imageType = await retrieveActiveImageConnectorType();

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_imageConnectionStringKey).then<ProviderInstance?>((String value) {

      switch(imageType!) {
        case ImageConnectorType.cloudinary:
          return CloudinaryInstance.fromString(value);
        case ImageConnectorType.local:
          throw Exception(_errorLocalTypeNotSupported);
        default:
          return null;
      }

    }, onError: (Object error) => null);

  }

  static Future<ItemConnector?> retrieveActiveItemConnector() async {

    final ItemConnectorType? itemType = await retrieveActiveItemConnectorType();

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_itemConnectionStringKey).then<ItemConnector?>((String value) {

      switch(itemType!) {
        case ItemConnectorType.postgres:
          return PostgresConnector.fromConnectionString(value);
        case ItemConnectorType.local:
          throw Exception(_errorLocalTypeNotSupported);
        default:
        return null;
      }

    }, onError: (Object error) => null);

  }

  static Future<ImageConnector?> retrieveActiveImageConnector() async {

    final ImageConnectorType? imageType = await retrieveActiveImageConnectorType();

    final EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences();

    return sharedPreferences.getString(_imageConnectionStringKey).then<ImageConnector?>((String value) {

      switch(imageType) {
        case ImageConnectorType.cloudinary:
          return CloudinaryConnector.fromConnectionString(value);
        case ImageConnectorType.local:
          throw Exception(_errorLocalTypeNotSupported);
        default:
          return null;
      }

    }, onError: (Object error) => null);

  }
}