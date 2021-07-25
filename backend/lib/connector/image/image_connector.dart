export '../provider_instance.dart';


abstract class ImageConnector {
  //#region UPLOAD
  Future<String> set({required String imagePath, required String tableName, required String imageName});
  //#endregion UPLOAD

  //#region RENAME
  Future<String> rename({required String tableName, required String oldImageName, required String newImageName});
  //#endregion RENAME

  //#region DELETE
  Future<dynamic> delete({required String tableName, required String imageName});
  //#endregion DELETE

  //#region DOWNLOAD
  String getURI({required String tableName, required String imageFilename});
  //#endregion DOWNLOAD
}