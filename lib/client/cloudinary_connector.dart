import 'dart:async';

import 'package:meta/meta.dart';

import 'cloudinary_connection/cloudinary_connection.dart';
import 'cloudinary_connection/cloudinary_response.dart';

import 'iimage_connector.dart';


const String baseAPIURL = 'https://api.cloudinary.com/v1_1/';
const String baseRESURL = 'http://res.cloudinary.com/';

class CloudinaryConnector extends IImageConnector {

  CloudinaryInstance _instance;
  CloudinaryConnection _connection;

  CloudinaryConnector() {

    try {
      //TODO load from json
      throw Exception();

    } catch (Exception) {
      print("json not provided, resorting to temporary connection");

      this._instance = CloudinaryInstance.fromString(_tempConnectionString);
    }

    _connection = new CloudinaryConnection(
      _instance._apiKey,
      _instance._apiSecret,
      _instance._cloudName,
    );
  }

  //#region UPLOAD
  @override
  Future<String> uploadImage({@required String imagePath, @required String tableName, @required String imageName}) {

    return _connection.uploadImage(
      imagePath,
      folder: tableName,
      imageFilename: imageName,
    ).asStream().map( getOnlyName ).first;

  }
  //#endregion UPLOAD

  //#region RENAME
  Future<String> renameImage({@required String tableName, @required String oldImageName, @required String newImageName}) {

    return _connection.renameImage(
      folder: tableName,
      imageFilename: oldImageName,
      newImageFilename: newImageName,
    ).asStream().map( getOnlyName ).first;

  }
  //#endregion RENAME

  //#region DOWNLOAD
  @override
  String getDownloadURL({@required String tableName, @required String imageName}) {

    String baseURL = getCompleteResURL(tableName, imageName);

    return baseURL;

  }
  //#endregion DOWNLOAD


  //#region Helpers
  String getCompleteResURL(String folderName, String imageName) {

    String url = baseRESURL + _instance._cloudName + '/image/upload/$folderName/$imageName.jpg';

    return url;

  }

  String getCompleteAPIURL() {

    String url = baseAPIURL + _instance._cloudName + "/image/upload";

    return url;

  }

  String getOnlyName(CloudinaryResponse response) {

    return response.public_id.split('/')[1];

  }
  //#endregion Helpers

}

const cloudinaryURIPattern = "cloudinary:\\\/\\\/(?<key>[^:]*):(?<secret>[^@]*)@(?<name>[^:]*)\$";
const String _tempConnectionString = "***REMOVED***";

class CloudinaryInstance {

  final String _cloudName;
  final String _apiKey;
  final String _apiSecret;

  CloudinaryInstance._(this._cloudName, this._apiKey, this._apiSecret);

  factory CloudinaryInstance.fromString(String connectionString) {

    RegExp pattern = RegExp(cloudinaryURIPattern);

    RegExpMatch match = pattern.firstMatch(connectionString);

    if (match == null) {
      throw Exception("Could not parse Cloudinary connection string.");
    }

    return CloudinaryInstance._(
      match.namedGroup('name'),
      match.namedGroup('key'),
      match.namedGroup('secret'),
    );

  }

}



//#region UPLOAD

//#endregion UPLOAD

//#region DOWNLOAD

//#endregion DOWNLOAD