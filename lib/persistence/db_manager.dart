import 'db_connector.dart';
import 'image_connector.dart';
import 'postgres_connector.dart';
import 'cloudinary_connector.dart';

class DBManager {

  IDBConnector _dbConnector;
  IImageConnector _imageConnector;

  DBManager._() {
    _dbConnector = PostgresConnector();
    _imageConnector = CloudinaryConnector();
  }

  static DBManager _singleton;
  factory DBManager() {
    if(_singleton == null) {
      _singleton = DBManager._();
    }

    return _singleton;
  }

  IDBConnector getDBConnector() {

    return _dbConnector;

  }

  IImageConnector getImageConnector() {

    return _imageConnector;

  }

}