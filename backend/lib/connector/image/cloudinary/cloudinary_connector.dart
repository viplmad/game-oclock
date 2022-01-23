// ignore_for_file: overridden_fields

import 'package:cloudinary_client/cloudinary_client.dart';

import '../image_connector.dart';


const String _baseAPIURL = 'https://api.cloudinary.com/v1_1/';
const String _baseRESURL = 'https://res.cloudinary.com/';

class CloudinaryConnector extends ImageConnector {
  CloudinaryConnector.fromConnectionString(String connectionString) {

    _instance = CloudinaryInstance.fromString(connectionString);
    createConnection();

  }

  late CloudinaryInstance _instance;
  late Image _connection;

  void createConnection() {

    _connection = Image(
      Credentials(
        _instance.apiKey.toString(),
        _instance.apiSecret,
        _instance.cloudName,
      ),
    );

  }

  //#region UPLOAD
  @override
  Future<String> set({required String imagePath, required String tableName, required String imageName}) {

    return _connection.upload(
      imagePath,
      filename: imageName,
      folder: tableName,
    ).asStream().map( getFilename ).first;

  }
  //#endregion UPLOAD

  //#region RENAME
  @override
  Future<String> rename({required String tableName, required String oldImageName, required String newImageName}) {

    return _connection.rename(
      filename: oldImageName,
      newFilename: newImageName,
      folder: tableName,
    ).asStream().map( getFilename ).first;

  }
  //#endregion RENAME

  //#region DELETE
  @override
  Future<Object?> delete({required String tableName, required String imageName}) {

    return _connection.delete(
      filename: imageName,
      folder: tableName,
    ).asStream().first;

  }
  //#endregion DELETE

  //#region DOWNLOAD
  @override
  String getURI({required String tableName, required String imageFilename}) {

    final String baseURL = getCompleteResURL(tableName, imageFilename);

    return baseURL;

  }
  //#endregion DOWNLOAD


  //#region Helpers
  String getCompleteResURL(String folderName, String imageFilename) {

    final String url = _baseRESURL + _instance.cloudName + '/image/upload/$folderName/$imageFilename';

    return url;

  }

  String getCompleteAPIURL() {

    final String url = _baseAPIURL + _instance.cloudName + '/image/upload';

    return url;

  }

  String getFilename(CloudinaryResponse response) {
    String filename = '';

    if(response is CloudinaryResponseSuccess) {
      filename = response.publicId!.split('/').last + '.' + response.format!;
    } else if(response is CloudinaryResponseError) {
      throw Exception(response.error);
    }

    if(filename.isEmpty) {
      throw const FormatException('Error obtaining image filename');
    }

    return filename;

  }
  //#endregion Helpers
}

const String _cloudinaryURIPattern = 'cloudinary:\\/\\/(?<key>[^:]*):(?<secret>[^@]*)@(?<name>[^:]*)\$';

class CloudinaryInstance extends ProviderInstance {
  const CloudinaryInstance(this.cloudName, this.apiKey, this.apiSecret);

  final String cloudName;
  final int apiKey;
  final String apiSecret;

  factory CloudinaryInstance.fromString(String connectionString) {

    final RegExp pattern = RegExp(_cloudinaryURIPattern);

    final RegExpMatch? match = pattern.firstMatch(connectionString);

    if (match == null) {
      throw const FormatException('Could not parse Cloudinary connection string.');
    }

    return CloudinaryInstance(
      match.namedGroup('name')?? '',
      int.parse(match.namedGroup('key')?? '-1'),
      match.namedGroup('secret')?? '',
    );

  }

  @override
  String connectionString() {

    return 'cloudinary://$apiKey:$apiSecret@$cloudName';

  }
}

class CloudinaryCredentials extends CloudinaryInstance {
  CloudinaryCredentials() : cloudName = '', apiKey = -1, apiSecret = '', super('', -1, '');

  @override
  String cloudName;
  @override
  int apiKey;
  @override
  String apiSecret;
}