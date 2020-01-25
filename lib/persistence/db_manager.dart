import 'db_connector.dart';
import 'postgres_connector.dart';

class DBManager {

  DBConnector _dbConnector;

  DBManager._() {
    _dbConnector = PostgresConnector();
  }

  static DBManager _singleton;
  factory DBManager() {
    if(_singleton == null) {
      _singleton = DBManager._();
    }

    return _singleton;
  }

  DBConnector getConnector() {

    return _dbConnector;

  }

}