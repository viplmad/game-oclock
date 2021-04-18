import 'package:postgres/postgres.dart';

import 'package:game_collection/entity/entity.dart';

import '../builder/builder.dart';
import '../isql_connector.dart';


class PostgresConnector extends ISQLConnector {
  PostgresConnector.fromConnectionString(String connectionString) {

    this._instance = PostgresInstance.fromString(connectionString);
    createConnection();

    this._queryBuilderOptions.allowAliasInFields = false;
    this._queryBuilderOptions.quoteStringWithFieldsTablesSeparator = false;

  }

  late PostgresInstance _instance;
  late PostgreSQLConnection _connection;
  final QueryBuilderOptions _queryBuilderOptions = QueryBuilderOptions();

  void createConnection() {

    this._connection = PostgreSQLConnection(
      _instance.host,
      _instance.port,
      _instance.database,
      username: _instance.user,
      password: _instance.password,
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
  Future<List<Map<String, Map<String, dynamic>>>> insertRecord({required String tableName, required Map<String, dynamic> fieldsAndValues, List<String>? returningFields}) {

    final String sql = _insertStatement(tableName);

    String fieldNamesForSQL = '';
    String fieldValuesForSQL = '';
    fieldsAndValues.forEach( (String fieldName, dynamic value) {

      fieldNamesForSQL += _forceDoubleQuotes(fieldName) + ', ';

      fieldValuesForSQL += '@' + fieldName + ', ';

    });
    fieldNamesForSQL = fieldNamesForSQL.substring(0, fieldNamesForSQL.length-2);
    fieldValuesForSQL = fieldValuesForSQL.substring(0, fieldValuesForSQL.length-2);

    return _connection.mappedResultsQuery(
      sql + ' (' + fieldNamesForSQL + ') VALUES(' + fieldValuesForSQL + ') ' + _returningStatement(returningFields),
      substitutionValues: fieldsAndValues,
    );

  }

  @override
  Future<dynamic> insertRelation({required String leftTableName, required String rightTableName, required int leftTableId, required int rightTableId}) {

    final String relationTable = _relationTable(leftTableName, rightTableName);

    final String sql = _insertStatement(relationTable);

    return _connection.mappedResultsQuery(
      sql + ' VALUES(@leftId, @rightId) ',
      substitutionValues: <String, dynamic>{
        'leftId' : leftTableId,
        'rightId' : rightTableId,
      },
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTable({required String tableName, List<String>? selectFields, List<dynamic>? tableArguments, Map<String, dynamic>? fieldsAndValues, List<String>? sortFields, int? limitResults}) {

    final String sql = _selectAllStatement(tableName, selectFields, tableArguments) + _whereStatement(fieldsAndValues?.keys.toList(growable: false)) + _orderByStatement(sortFields) + _limitStatement(limitResults);

    /*QueryBuilder queryBuilder = FluentQuery
        .select(options: this._queryBuilderOptions)
        .fields(selectFields ?? <String>[], tableName: 'a')
        .from(tableName, alias: 'a');
    if(fieldsAndValues != null) {
      for(final String field in fieldsAndValues.keys) {
        queryBuilder = queryBuilder.where('$field = @$field');
      }
    }

    if(sortFields != null) {
      for(final String field in sortFields) {
        queryBuilder = queryBuilder.order(field);
      }
    }

    if(limitResults != null) {
      queryBuilder = queryBuilder.limit(limitResults);
    }

    final String tempSql = queryBuilder.toSql();*/

    return _connection.mappedResultsQuery(
      sql,
      substitutionValues: fieldsAndValues,
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readJoinTable({required String leftTable, required String rightTable, required String leftTableId, required String rightTableId, required List<String> leftSelectFields, required List<String> rightSelectFields, required String where, Map<String, dynamic>? fieldsAndValues, List<String>? sortFields}) {

    final String leftAlias = 'a';
    final String rightAlias = 'b';
    final String sql = 'SELECT ' + _formatSelectionFields(leftSelectFields, leftAlias) + ', ' + _formatSelectionFields(rightSelectFields, rightAlias) + _leftJoinStatement(leftTable, rightTable, leftTableId, rightTableId, leftAlias, rightAlias) + ' WHERE ' + where + _orderByStatement(sortFields);

    return _connection.mappedResultsQuery(
      sql,
      substitutionValues: fieldsAndValues,
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String leftTableName, required String rightTableName, required bool leftResults, required int relationId, List<String>? selectFields, List<String>? sortFields}) {

    final String relationTable = _relationTable(leftTableName, rightTableName);
    final String leftIdField = _relationIdField(leftTableName);
    final String rightIdField = _relationIdField(rightTableName);

    final String sql = _selectJoinStatement(
      leftResults? leftTableName : rightTableName,
      relationTable,
      idField,
      leftResults? leftIdField : rightIdField,
      selectFields,
    );

    return _connection.mappedResultsQuery(
      sql + ' WHERE + ' + _forceDoubleQuotes(leftResults? rightIdField : leftIdField) + ' = @relationId ' + _orderByStatement(sortFields),
      substitutionValues: <String, dynamic>{
        'relationId' : relationId,
      },
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String relationField, required int relationId, bool primaryResults = false, List<String>? selectFields, List<String>? sortFields}) {

    String sql = _selectStatement(selectFields, (primaryResults? 'a' : 'b'));

    sql += ' FROM ' + _forceDoubleQuotes(subordinateTable) + ' b JOIN ' + _forceDoubleQuotes(primaryTable) + ' a '
        + ' ON b.' + _forceDoubleQuotes(relationField) + ' = a.' + _forceDoubleQuotes(idField) + ' ';

    return _connection.mappedResultsQuery(
      sql + ' WHERE ' + (primaryResults? 'b' : 'a') + '.' + _forceDoubleQuotes(idField) + ' = @relationId' + _orderByStatement(sortFields),
      substitutionValues: <String, dynamic>{
        'relationId' : relationId,
      },
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({required String tableName, required String searchField, required String query, List<String>? fieldNames, required int limitResults}) {

    query = _searchableQuery(query);

    final String sql = _selectAllStatement(tableName, fieldNames);

    return _connection.mappedResultsQuery(
      sql + ' WHERE ' + _forceDoubleQuotes(searchField) + ' ILIKE @query LIMIT ' + limitResults.toString(),
      substitutionValues: <String, dynamic>{
        'query' : query,
      },
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<dynamic> updateTable<T>({required String tableName, required Map<String, dynamic> fieldsAndValues, required String fieldName, required T? newValue}) {

    if(newValue == null) {
      return _updateTableToNull(
        tableName: tableName,
        whereFieldsAndValues: fieldsAndValues,
        fieldName: fieldName,
      );
    }

    final String sql = _updateStatement(tableName);

    return _connection.mappedResultsQuery(
      sql + ' SET ' + _forceDoubleQuotes(fieldName) + ' = @newValue ' + _whereStatement(fieldsAndValues.keys.toList(growable: false)),
      substitutionValues: fieldsAndValues..addEntries(<MapEntry<String, dynamic>>{
        MapEntry<String, dynamic>('newValue', newValue),
      }),
    );

  }

  Future<dynamic> _updateTableToNull({required String tableName, required Map<String, dynamic> whereFieldsAndValues, required String fieldName}) {

    final String sql = _updateStatement(tableName);

    return _connection.mappedResultsQuery(
      sql + ' SET ' + _forceDoubleQuotes(fieldName) + ' = NULL ' + _whereStatement(whereFieldsAndValues.keys.toList(growable: false)),
      substitutionValues: whereFieldsAndValues,
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteTable({required String tableName, required Map<String, dynamic> fieldsAndValues}) {

    final String sql = _deleteStatement(tableName);

    return _connection.mappedResultsQuery(
      sql + _whereStatement(fieldsAndValues.keys.toList(growable: false)),
      substitutionValues: fieldsAndValues,
    );

  }

  @override
  Future<dynamic> deleteRelation({required String leftTableName, required String rightTableName, required int leftId, required int rightId}) {

    final String relationTable = _relationTable(leftTableName, rightTableName);
    final String leftIdField = _relationIdField(leftTableName);
    final String rightIdField = _relationIdField(rightTableName);

    final String sql = _deleteStatement(relationTable);

    return _connection.mappedResultsQuery(
      sql + ' WHERE + ' + _forceDoubleQuotes(leftIdField) + ' = @leftId AND ' + _forceDoubleQuotes(rightIdField) + ' = @rightId ',
      substitutionValues: <String, dynamic>{
        'leftId' : leftId,
        'rightId' : rightId,
      },
    );

  }
  //#endregion DELETE


  //#region Helpers
  String _selectStatement([List<String>? fieldNames, String alias = '']) {

    String selection = ' * ';
    if(fieldNames != null) {
      selection = _formatSelectionFields(fieldNames, alias);
    }

    return 'SELECT ' + selection;

  }

  String _selectAllStatement(String table, [List<String>? fieldNames, List<dynamic>? tableArguments]) {

    String tableString = _forceDoubleQuotes(table);
    if(tableArguments != null) {
      tableString += '(' + _forceArgumentsSingleQuotes(tableArguments).join(', ') + ')';
    }

    return _selectStatement(fieldNames) + ' FROM ' + tableString;

  }

  String _selectJoinStatement(String leftTable, String rightTable, String leftTableId, String rightTableId, [List<String>? selectFields]) {

    return _selectStatement(selectFields) + ' FROM ' + _forceDoubleQuotes(leftTable) + ' JOIN ' + _forceDoubleQuotes(rightTable) + ' ON ' + _forceDoubleQuotes(leftTableId) + ' = ' + _forceDoubleQuotes(rightTableId) + ' ';

  }

  String _leftJoinStatement(String leftTable, String rightTable, String leftTableId, String rightTableId, [String leftAlias = '', String rightAlias = '']) {

    final String leftAliasDot = (leftAlias.isNotEmpty)? leftAlias + '.' : '';
    final String rightAliasDot = (rightAlias.isNotEmpty)? rightAlias + '.' : '';
    return ' FROM ' + _forceDoubleQuotes(leftTable) + ' ' + leftAlias + ' LEFT JOIN ' + _forceDoubleQuotes(rightTable) + ' ' + rightAlias + ' ON ' + leftAliasDot + _forceDoubleQuotes(leftTableId) + ' = ' + rightAliasDot + _forceDoubleQuotes(rightTableId) + ' ';

  }

  String _orderByStatement(List<String>? sortFields) {

    return sortFields != null? ' ORDER BY ' + _forceFieldsDoubleQuotes(sortFields).join(', ') : '';

  }

  String _limitStatement(int? limit) {

    return limit != null? ' LIMIT ' + limit.toString() : '';

  }

  String _whereStatement(List<String>? filterFields) {

    if(filterFields != null) {

      String filterForSQL = '';
      filterFields.forEach( (String fieldName) {

        filterForSQL += _forceDoubleQuotes(fieldName) + ' = @' + fieldName + ' AND ';

      });
      //Remove trailing AND
      filterForSQL = filterForSQL.substring(0, filterForSQL.length-4);

      return ' WHERE ' + filterForSQL;
    }

    return '';

  }

  String _updateStatement(String table) {

    return 'UPDATE ' + _forceDoubleQuotes(table);

  }

  String _insertStatement(String table) {

    return 'INSERT INTO ' + _forceDoubleQuotes(table);

  }

  String _deleteStatement(String table) {

    return 'DELETE FROM ' + _forceDoubleQuotes(table);

  }

  String _returningStatement([List<String>? fieldNames]) {

    String selection = ' * ';
    if(fieldNames != null) {
      selection = _formatSelectionFields(fieldNames);
    }

    return ' RETURNING ' + selection;

  }

  String _searchableQuery(String query) {

    return '%' + query + '%';

  }

  String _forceDoubleQuotes(String text) {

    return '\"' + text + '\"';

  }

  String _forceSingleQuotes(String text) {

    return '\'' + text + '\'';

  }

  List<String> _forceFieldsDoubleQuotes(List<String> fields) {

    return fields.map( (String field) => _forceDoubleQuotes(field) ).toList(growable: false);

  }

  List<String> _forceArgumentsSingleQuotes(List<dynamic> arguments) {

    return arguments.map( (dynamic field) => _forceSingleQuotes(field.toString()) ).toList(growable: false);

  }

  String _formatSelectionFields(List<String> fieldNames, [String alias = '']) {

    alias = (alias.isNotEmpty)? alias + '.' : '';

    String fieldNamesForSQL = '';
    fieldNames.forEach( (String fieldName) {

      final String _formattedField = alias + _forceDoubleQuotes(fieldName);

      if(fieldName == purc_priceField
          || fieldName == purc_externalCreditField
          || fieldName == purc_originalPriceField) {

        fieldNamesForSQL += _formattedField + '::float';

      } else if(fieldName == game_timeField
          || fieldName == gameLog_timeField) {

        fieldNamesForSQL += '(Extract(hours from ' + _formattedField + ') * 60 + EXTRACT(minutes from ' + _formattedField + '))::int AS ' + _forceDoubleQuotes(fieldName);

      } else {

        fieldNamesForSQL += _formattedField;

      }

      fieldNamesForSQL += ', ';

    });
    //Remove trailing comma
    fieldNamesForSQL = fieldNamesForSQL.substring(0, fieldNamesForSQL.length-2);

    return fieldNamesForSQL;

  }

  String _relationTable(String leftTable, String rightTable) {

    return leftTable + '-' + rightTable;

  }

  String _relationIdField(String table) {

    return table + '_' + idField;

  }
  //#endregion Helpers
}

const String _postgresURIPattern = '^postgres:\\\/\\\/(?<user>[^:]*):(?<pass>[^@]*)@(?<host>[^:]*):(?<port>[^\\\/]*)\\\/(?<db>[^\/]*)\$';

class PostgresInstance {
  const PostgresInstance(this.host, this.port, this.database, this.user, this.password);

  final String host;
  final int port;
  final String database;
  final String user;
  final String password;

  factory PostgresInstance.fromString(String connectionString) {

    final RegExp pattern = RegExp(_postgresURIPattern);

    final RegExpMatch? match = pattern.firstMatch(connectionString);

    if (match == null) {
      throw const FormatException('Could not parse Postgres connection string.');
    }

    return PostgresInstance(
      match.namedGroup('host')?? '',
      int.parse(match.namedGroup('port')?? '-1'),
      match.namedGroup('db')?? '',
      match.namedGroup('user')?? '',
      match.namedGroup('pass')?? '',
    );

  }

  String connectionString() {

    return 'postgres://$user:$password@$host:$port/$database';

  }
}