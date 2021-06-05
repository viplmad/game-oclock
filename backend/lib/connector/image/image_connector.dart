abstract class ImageConnector {
  //#region UPLOAD
  Future<String> setImage({required String imagePath, required String tableName, required String imageName});
  //#endregion UPLOAD

  //#region RENAME
  Future<String> renameImage({required String tableName, required String oldImageName, required String newImageName});
  //#endregion RENAME

  //#region DELETE
  Future<dynamic> deleteImage({required String tableName, required String imageName});
  //#endregion DELETE

  //#region DOWNLOAD
  String getURI({required String tableName, required String imageFilename});
  //#endregion DOWNLOAD
}