import 'package:meta/meta.dart';

import 'package:postgres/postgres.dart';

import 'package:game_collection/entity/entity.dart';

import 'idb_connector.dart';


class PostgresConnector extends IDBConnector {

  PostgresInstance _instance;
  PostgreSQLConnection _connection;

  PostgresConnector() {

    try {
      //TODO load from json
      throw Exception();

    } catch (Exception) {
      print("json not provided, resorting to temporary connection");

      this._instance = PostgresInstance.fromString(_tempConnectionString);
    }

    createConnection();

  }

  void createConnection() {

    _connection = new PostgreSQLConnection(
      _instance._host,
      _instance._port,
      _instance._database,
      username: _instance._user,
      password: _instance._password,
      useSSL: true,
    );

  }

  @override
  Future<dynamic> open() {

    return _connection.open();

  }

  @override
  Future<dynamic> close() {

    return _connection.close();

  }

  @override
  bool isClosed() {

    return _connection.isClosed;

  }

  @override
  bool isOpen() {

    return !this.isClosed();

  }

  @override
  bool isUpdating() {

    return _connection.queueSize != 0;

  }

  @override
  void reconnect() {

    createConnection();

  }

  //#region CREATE
  @override
  Future<List<Map<String, Map<String, dynamic>>>> insertRecord({@required String tableName, Map<String, dynamic> fieldAndValues, List<String> returningFields}) {

    String sql = _insertStatement(tableName);

    String fieldNamesForSQL = "";
    String fieldValuesForSQL = "";
    fieldAndValues.forEach( (String fieldName, dynamic value) {

      fieldNamesForSQL += _forceDoubleQuotes(fieldName) + ", ";

      fieldValuesForSQL += "@" + fieldName + ", ";

    });
    fieldNamesForSQL = fieldNamesForSQL.substring(0, fieldNamesForSQL.length-2);
    fieldValuesForSQL = fieldValuesForSQL.substring(0, fieldValuesForSQL.length-2);

    return _connection.mappedResultsQuery(sql + " (" + fieldNamesForSQL + ") VALUES(" + fieldValuesForSQL + ") " + _returningStatement(returningFields),
      substitutionValues: fieldAndValues,
    );

  }

  @override
  Future<dynamic> insertRelation({@required String leftTableName, @required String rightTableName, @required int leftTableID, @required int rightTableID}) {

    String relationTable = _relationTable(leftTableName, rightTableName);

    String sql = _insertStatement(relationTable);

    return _connection.mappedResultsQuery(sql + " VALUES(@leftID, @rightID) ", substitutionValues: {
      "leftID" : leftTableID,
      "rightID" : rightTableID,
    });

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTable({@required String tableName, List<String> selectFields, Map<String, dynamic> whereFieldsAndValues, List<String> sortFields, int limitResults}) {

    String sql = _selectAllStatement(tableName, selectFields) + _whereStatement(whereFieldsAndValues?.keys?.toList(growable: false)?? null) + _orderByStatement(sortFields) + _limitStatement(limitResults);

    return _connection.mappedResultsQuery(sql, substitutionValues: whereFieldsAndValues);

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({@required String leftTableName, @required String rightTableName, @required bool leftResults, @required int relationID, List<String> selectFields, List<String> sortFields}) {

    String relationTable = _relationTable(leftTableName, rightTableName);
    String leftIDField = _relationIDField(leftTableName);
    String rightIDField = _relationIDField(rightTableName);

    String sql = _selectJoinStatement(
      leftResults? leftTableName : rightTableName,
      relationTable,
      IDField,
      leftResults? leftIDField : rightIDField,
      selectFields,
    );

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(leftResults? rightIDField : leftIDField) + " = @relationID " + _orderByStatement(sortFields), substitutionValues: {
      "relationID" : relationID,
    });

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({@required String primaryTable, @required String subordinateTable, @required String relationField, @required int relationID, bool primaryResults = false, List<String> selectFields, List<String> sortFields}) {

    String sql = _selectStatement(selectFields, (primaryResults? 'a' : 'b'));

    sql += " FROM " + _forceDoubleQuotes(subordinateTable) + " b JOIN " + _forceDoubleQuotes(primaryTable) + " a "
        + " ON b." + _forceDoubleQuotes(relationField) + " = a." + _forceDoubleQuotes(IDField) + " ";

    return _connection.mappedResultsQuery(sql + " WHERE " + (primaryResults? "b" : "a") + "." + _forceDoubleQuotes(IDField) + " = @relationID" + _orderByStatement(sortFields), substitutionValues: {
      "relationID" : relationID,
    });

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({@required String tableName, @required String searchField, @required String query, List<String> fieldNames, int limitResults}) {

    query = _searchableQuery(query);

    String sql = _selectAllStatement(tableName, fieldNames);

    return _connection.mappedResultsQuery(sql + " WHERE " + _forceDoubleQuotes(searchField) + " ILIKE @query LIMIT " + limitResults.toString(), substitutionValues: {
      "query" : query,
    });

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<List<Map<String, Map<String, dynamic>>>> updateTable<T>({@required String tableName, @required int ID, @required String fieldName, @required T newValue, List<String> returningFields}) {

    if(newValue == null) {
      return _updateTableToNull(
        tableName: tableName,
        ID: ID,
        fieldName: fieldName,
        returningFields: returningFields,
      );
    }

    String sql = _updateStatement(tableName);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(fieldName) + " = @newValue WHERE " + _forceDoubleQuotes(IDField) + " = @tableID " +  _returningStatement(returningFields), substitutionValues: {
      "newValue" : !(newValue is Duration)?
          newValue
          :
          //Duration is not supported, special case
          (newValue as Duration).inSeconds,
      "tableID" : ID,
    });

  }

  Future<List<Map<String, Map<String, dynamic>>>> _updateTableToNull({@required String tableName, @required int ID, @required String fieldName, List<String> returningFields}) {

    String sql = _updateStatement(tableName);

    return _connection.mappedResultsQuery(sql + " SET " + _forceDoubleQuotes(fieldName) + " = NULL WHERE " + _forceDoubleQuotes(IDField) + " = @tableID " +  _returningStatement(returningFields), substitutionValues: {
      "tableID" : ID,
    });

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteTable({@required String tableName, @required int ID}) {

    String sql = _deleteStatement(tableName);

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(IDField) + " = @ID ", substitutionValues: {
      "ID" : ID,
    });

  }

  @override
  Future<dynamic> deleteRelation({@required String leftTableName, @required String rightTableName, @required int leftID, @required int rightID}) {

    String relationTable = _relationTable(leftTableName, rightTableName);
    String leftIDField = _relationIDField(leftTableName);
    String rightIDField = _relationIDField(rightTableName);

    String sql = _deleteStatement(relationTable);

    return _connection.mappedResultsQuery(sql + " WHERE + " + _forceDoubleQuotes(leftIDField) + " = @leftID AND " + _forceDoubleQuotes(rightIDField) + " = @rightID ", substitutionValues: {
      "leftID" : leftID,
      "rightID" : rightID,
    });

  }
  //#endregion DELETE


  //#region Helpers
  String _selectStatement([List<String> fieldNames, String alias = '']) {

    String selection = ' * ';
    if(fieldNames != null) {
      selection = _formatSelectionFields(fieldNames, alias);
    }

    return "SELECT " + selection;

  }

  String _selectAllStatement(String table, [List<String> fieldNames]) {

    return _selectStatement(fieldNames) + " FROM " + _forceDoubleQuotes(table);

  }

  String _selectJoinStatement(String leftTable, String rightTable, String leftTableID, String rightTableID, [List<String> selectFields]) {

    return _selectStatement(selectFields) + " FROM \"" + leftTable + "\" JOIN \"" + rightTable + "\" ON \"" + leftTableID + "\" = \"" + rightTableID + "\" ";

  }

  String _orderByStatement(List<String> sortFields) {

    return sortFields != null? " ORDER BY " + _forceFieldsDoubleQuotes(sortFields).join(", ") : "";

  }

  String _limitStatement(int limit) {

    return limit != null? " LIMIT " + limit.toString() : "";

  }

  String _whereStatement(List<String> filterFields) {

    if(filterFields != null) {

      String filterForSQL = "";
      filterFields.forEach( (String fieldName) {

        filterForSQL += _forceDoubleQuotes(fieldName) + " = @" + fieldName + " AND ";

      });
      //Remove trailing AND
      filterForSQL = filterForSQL.substring(0, filterForSQL.length-4);

      return " WHERE " + filterForSQL;
    }

    return "";

  }

  String _updateStatement(String table) {

    return "UPDATE " + _forceDoubleQuotes(table);

  }

  String _insertStatement(String table) {

    return "INSERT INTO " + _forceDoubleQuotes(table);

  }

  String _deleteStatement(String table) {

    return "DELETE FROM " + _forceDoubleQuotes(table);

  }

  String _returningStatement([List<String> fieldNames]) {

    String selection = ' * ';
    if(fieldNames != null) {
      selection = _formatSelectionFields(fieldNames);
    }

    return " RETURNING " + selection;

  }

  String _searchableQuery(String query) {

    return "%" + query + "%";

  }

  String _forceDoubleQuotes(String text) {

    return "\"" + text + "\"";

  }

  List<String> _forceFieldsDoubleQuotes(List<String> fields) {

    return fields.map( (String field) => _forceDoubleQuotes(field) ).toList(growable: false);

  }

  String _formatSelectionFields(List<String> fieldNames, [String alias = '']) {

    alias = (alias != null && alias != '')? alias + '.' : '';

    String fieldNamesForSQL = "";
    fieldNames.forEach( (String fieldName) {

      String _formattedField = alias + _forceDoubleQuotes(fieldName);

      if(fieldName == purc_priceField
          || fieldName == purc_externalCreditField
          || fieldName == purc_originalPriceField) {

        fieldNamesForSQL += _formattedField + "::float";

      } else if(fieldName == game_timeField) {

        fieldNamesForSQL += "(Extract(hours from " + _formattedField + ") * 60 + EXTRACT(minutes from " + _formattedField + "))::int AS " + _forceDoubleQuotes(fieldName);

      } else {

        fieldNamesForSQL += _formattedField;

      }

      fieldNamesForSQL += ", ";

    });
    //Remove trailing comma
    fieldNamesForSQL = fieldNamesForSQL.substring(0, fieldNamesForSQL.length-2);

    return fieldNamesForSQL;

  }

  String _relationTable(String leftTable, String rightTable) {

    return leftTable + "-" + rightTable;

  }

  String _relationIDField(String table) {

    return table + "_" + IDField;

  }
  //#endregion Helpers

}


const herokuURIPattern = "^postgres:\\\/\\\/(?<user>[^:]*):(?<pass>[^@]*)@(?<host>[^:]*):(?<port>[^\\\/]*)\\\/(?<db>[^\/]*)\$";
const String _tempConnectionString = "***REMOVED***";

class PostgresInstance {

  final String _host;
  final int _port;
  final String _database;
  final String _user;
  final String _password;

  PostgresInstance._(this._host, this._port, this._database, this._user, this._password);

  factory PostgresInstance.fromString(String connectionString) {

    RegExp pattern = RegExp(herokuURIPattern);

    RegExpMatch match = pattern.firstMatch(connectionString);

    if (match == null) {
      throw Exception("Could not parse Postgres connection string.");
    }

    return PostgresInstance._(
      match.namedGroup('host'),
      int.parse(match.namedGroup('port')),
      match.namedGroup('db'),
      match.namedGroup('user'),
      match.namedGroup('pass'),
    );

  }

}