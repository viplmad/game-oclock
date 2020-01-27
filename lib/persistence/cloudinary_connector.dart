import 'dart:async';
import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:game_collection/persistence/cloudinary_client/cloudinary_client.dart';
import 'package:game_collection/persistence/cloudinary_client/cloudinary_response.dart';
import 'package:http/http.dart';

import 'image_connector.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/dlc.dart' as dlcEntity;
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;
import 'package:game_collection/entity/platform.dart' as platformEntity;
import 'package:game_collection/entity/store.dart' as storeEntity;
import 'package:game_collection/entity/system.dart' as systemEntity;
import 'package:game_collection/entity/tag.dart' as tagEntity;
import 'package:game_collection/entity/type.dart' as typeEntity;


const String baseAPIURL = 'https://api.cloudinary.com/v1_1/';
const String baseRESURL = 'http://res.cloudinary.com/';

class CloudinaryConnector implements IImageConnector {

  CloudinaryInstance _instance;
  CloudinaryClient _connection;

  CloudinaryConnector() {

    try {
      //TODO load from json
      throw Exception();

    } catch (Exception) {
      print("json not provided, resorting to temporary connection");

      this._instance = CloudinaryInstance.fromString(_tempConnectionString);
    }

    _connection = new CloudinaryClient(
      _instance._apiKey,
      _instance._apiSecret,
      _instance._cloudName,
    );
  }

  @override
  Future<dynamic> open() {

    return null;

  }

  @override
  Future<dynamic> close() {

    return null;

  }

  @override
  bool isClosed() {

    return false;

  }

  @override
  bool isOpen() {

    return !this.isClosed();

  }

  @override
  bool isUpdating() {

    return false;

  }

  //#region Generic Queries
  Future<Image> _downloadImage(String imageURL) {
    // TODO: revise, may not need method
    return null;
  }

  Future<CloudinaryResponse> _uploadImage({@required String imagePath, @required String tableName, @required String imageName}) {

    return _connection.uploadImage(
      imagePath,
      folder: tableName,
      filename: imageName,
      overwrite: true,
    );

  }
  //#endregion Generic Queries

  //#region UPLOAD
  @override
  Future<dynamic> uploadGameCover(int gameID, String uploadImagePath) {

    return _uploadImage(
      imagePath: uploadImagePath,
      tableName: gameEntity.gameTable,
      imageName: gameID.toString(),
    );

  }
  //#endregion UPLOAD

  //#region DOWNLOAD
  @override
  String getGameCoverURL(int gameID) {

    String baseURL = getCompleteResURL(gameEntity.gameTable, gameID.toString());

    return baseURL;

  }
  //#endregion DOWNLOAD

  //#region Helpers
  String getCompleteResURL(String folderName, String imageName) {

    String url = baseRESURL + _instance._cloudName + '/image/upload/' + folderName + '/' + imageName + '.jpg';

    return url;

  }

  String getCompleteAPIURL() {

    String url = baseAPIURL + _instance._cloudName + "/image/upload";

    return url;

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