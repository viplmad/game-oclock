import 'dart:async';

import '../iimage_connector.dart';

import 'cloudinary_connection/cloudinary_connection.dart';
import 'cloudinary_connection/cloudinary_response.dart';


const String _baseAPIURL = 'https://api.cloudinary.com/v1_1/';
const String _baseRESURL = 'http://res.cloudinary.com/';

class CloudinaryConnector extends IImageConnector {
  CloudinaryConnector.fromConnectionString(String connectionString) {

    this._instance = CloudinaryInstance.fromString(connectionString);
    createConnection();

  }

  late CloudinaryInstance _instance;
  late CloudinaryConnection _connection;

  void createConnection() {

    this._connection = new CloudinaryConnection(
      _instance.apiKey.toString(),
      _instance.apiSecret,
      _instance.cloudName,
    );

  }

  //#region UPLOAD
  @override
  Future<String> setImage({required String imagePath, required String tableName, required String imageName}) {

    return _connection.uploadImage(
      imagePath,
      folder: tableName,
      imageName: imageName,
    ).asStream().map( getFilename ).first;

  }
  //#endregion UPLOAD

  //#region RENAME
  @override
  Future<String> renameImage({required String tableName, required String oldImageName, required String newImageName}) {

    return _connection.renameImage(
      folder: tableName,
      imageName: oldImageName,
      newImageName: newImageName,
    ).asStream().map( getFilename ).first;

  }
  //#endregion RENAME

  //#region DELETE
  @override
  Future<dynamic> deleteImage({required String tableName, required String imageName}) {

    return _connection.deleteImage(
      folder: tableName,
      imageName: imageName,
    ).asStream().first;

  }
  //#endregion DELETE

  //#region DOWNLOAD
  @override
  String getURI({required String tableName, required String imageFilename}) {

    String baseURL = getCompleteResURL(tableName, imageFilename);

    return baseURL;

  }
  //#endregion DOWNLOAD


  //#region Helpers
  String getCompleteResURL(String folderName, String imageFilename) {

    String url = _baseRESURL + _instance.cloudName + '/image/upload/$folderName/$imageFilename';

    return url;

  }

  String getCompleteAPIURL() {

    String url = _baseAPIURL + _instance.cloudName + '/image/upload';

    return url;

  }

  String getFilename(CloudinaryResponse response) {

    String filename = '';
    if(!response.isError) {
      filename = response.publicId!.split('/').last + '.' + response.format!;
    }

    return filename;

  }
  //#endregion Helpers
}

const String _cloudinaryURIPattern = 'cloudinary:\\\/\\\/(?<key>[^:]*):(?<secret>[^@]*)@(?<name>[^:]*)\$';

class CloudinaryInstance {
  const CloudinaryInstance(this.cloudName, this.apiKey, this.apiSecret);

  final String cloudName;
  final int apiKey;
  final String apiSecret;

  factory CloudinaryInstance.fromString(String connectionString) {

    RegExp pattern = RegExp(_cloudinaryURIPattern);

    RegExpMatch? match = pattern.firstMatch(connectionString);

    if (match == null) {
      throw FormatException('Could not parse Cloudinary connection string.');
    }

    return CloudinaryInstance(
      match.namedGroup('name')?? '',
      int.parse(match.namedGroup('key')?? '-1'),
      match.namedGroup('secret')?? '',
    );

  }

  String connectionString() {

    return 'cloudinary://$apiKey:$apiSecret@$cloudName';

  }
}