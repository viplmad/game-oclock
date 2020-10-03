import 'package:meta/meta.dart';


abstract class IImageConnector {

  //#region UPLOAD
  Future<String> uploadImage({@required String imagePath, @required String tableName, @required String imageName});
  //#endregion UPLOAD

  //#region RENAME
  Future<String> renameImage({@required String tableName, @required String oldImageName, @required String newImageName});
  //#endregion RENAME

  //#region DELETE
  Future<dynamic> deleteImage({@required String tableName, @required String imageName});
  //#endregion DELETE

  //#region DOWNLOAD
  String getDownloadURL({@required String tableName, @required String imageFilename});
  //#ENDregion DOWNLOAD

}