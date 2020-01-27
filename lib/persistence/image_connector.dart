abstract class IImageConnector {

  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();


  //#region UPLOAD
  Future<dynamic> uploadGameCover(int gameID, String uploadImage);
  //#endregion UPLOAD

  //#region DOWNLOAD
  String getGameCoverURL(int gameID);
  //#ENDregion DOWNLOAD


}