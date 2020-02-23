import 'package:meta/meta.dart';


abstract class IImageConnector {

  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();


  //#region UPLOAD
  Future<String> uploadImage({@required String imagePath, @required String tableName, @required String imageName});
  //#endregion UPLOAD

  //#region DOWNLOAD
  String getDownloadURL({@required String tableName, @required String imageName});
  //#ENDregion DOWNLOAD


}