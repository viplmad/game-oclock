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

  /// Revise fields and values map to take into account special cases not covered by postgres connector (mainly Duration)
  void _reviseFieldsAndValues(Map<String, dynamic> fieldsAndValues) {

    fieldsAndValues.forEach( (String fieldName, dynamic value) {

      if(value is Duration) {
        fieldsAndValues[fieldName] = value.inSeconds;
      }

    });

  }

  //#region CREATE
  @override
  Future<List<Map<String, Map<String, dynamic>>>> insertRecord({required String tableName, required Map<String, dynamic> fieldsAndValues, String? idField}) {

    _reviseFieldsAndValues(fieldsAndValues);

    final QueryBuilder queryBuilder = FluentQuery.insert().into(tableName).setAll(fieldsAndValues);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql() + (idField != null? ' RETURNING ' + _forceDoubleQuotes(idField) : ''),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTable({required String tableName, Map<String, Type>? selectFields, List<dynamic>? tableArguments, Map<String, dynamic>? whereFieldsAndValues, List<String>? sortFields, int? limitResults}) {

    final String sql = _selectAllStatement(tableName, selectFields, tableArguments) + _whereStatement(whereFieldsAndValues?.keys.toList(growable: false)) + _orderByStatement(sortFields) + _limitStatement(limitResults);

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
      substitutionValues: whereFieldsAndValues,
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readJoinTable({required String leftTable, required String rightTable, required String leftTableId, required String rightTableId, required Map<String, Type> leftSelectFields, required Map<String, Type> rightSelectFields, required String where, Map<String, dynamic>? fieldsAndValues, List<String>? sortFields}) {

    final String leftAlias = 'a';
    final String rightAlias = 'b';
    final String sql = 'SELECT ' + _formatSelectionFields(leftSelectFields, leftAlias) + ', ' + _formatSelectionFields(rightSelectFields, rightAlias) + _leftJoinStatement(leftTable, rightTable, leftTableId, rightTableId, leftAlias, rightAlias) + ' WHERE ' + where + _orderByStatement(sortFields);

    return _connection.mappedResultsQuery(
      sql,
      substitutionValues: fieldsAndValues,
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String tableName, required String relationTable, required String joinField, required String relationField, required int relationId, Map<String, Type>? selectFields, List<String>? sortFields}) {

    final String sql = _selectJoinStatement(
      tableName,
      relationTable,
      idField,
      joinField,
      selectFields,
    );

    return _connection.mappedResultsQuery(
      sql + ' WHERE + ' + _forceDoubleQuotes(relationField) + ' = @relationId ' + _orderByStatement(sortFields),
      substitutionValues: <String, dynamic>{
        'relationId' : relationId,
      },
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String relationField, required int relationId, bool primaryResults = false, Map<String, Type>? selectFields, List<String>? sortFields}) {

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
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({required String tableName, required String searchField, required String query, Map<String, Type>? fields, required int limitResults}) {

    query = _searchableQuery(query);

    final String sql = _selectAllStatement(tableName, fields);

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
  Future<dynamic> updateTable<T>({required String tableName, required Map<String, dynamic> whereFieldsAndValues, required Map<String, dynamic> fieldsAndValues}) {

    _reviseFieldsAndValues(fieldsAndValues);

    QueryBuilder queryBuilder = FluentQuery.update().into(tableName).setAll(fieldsAndValues);
    whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

      final String _formattedField = _forceDoubleQuotes(fieldName);

      String value;
      if(fieldValue == null) {

        value = 'NULL';

      } else {

        value = '@' + fieldName;

      }

      queryBuilder = queryBuilder.where(_formattedField + ' = ' + value);

    });

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: whereFieldsAndValues..addEntries(fieldsAndValues.entries),
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteRecord({required String tableName, required Map<String, dynamic> whereFieldsAndValues}) {

    QueryBuilder queryBuilder = FluentQuery.delete().from(tableName);
    whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

      final String _formattedField = _forceDoubleQuotes(fieldName);

      String value;
      if(fieldValue == null) {

        value = 'NULL';

      } else {

        value = '@' + fieldName;

      }

      queryBuilder = queryBuilder.where(_formattedField + ' = ' + value);

    });

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: whereFieldsAndValues,
    );

  }
  //#endregion DELETE


  //#region Helpers
  String _selectStatement([Map<String, Type>? fields, String alias = '']) {

    String selection = ' * ';
    if(fields != null) {
      selection = _formatSelectionFields(fields, alias);
    }

    return 'SELECT ' + selection;

  }

  String _selectAllStatement(String table, [Map<String, Type>? fields, List<dynamic>? tableArguments]) {

    String tableString = _forceDoubleQuotes(table);
    if(tableArguments != null) {
      tableString += '(' + _forceArgumentsSingleQuotes(tableArguments).join(', ') + ')';
    }

    return _selectStatement(fields) + ' FROM ' + tableString;

  }

  String _selectJoinStatement(String leftTable, String rightTable, String leftTableId, String rightTableId, [Map<String, Type>? selectFields]) {

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

  String _formatSelectionFields(Map<String, Type> fields, [String alias = '']) {

    alias = (alias.isNotEmpty)? alias + '.' : '';

    String fieldNamesForSQL = '';
    fields.forEach( (String fieldName, Type fieldType) {

      final String _formattedField = alias + _forceDoubleQuotes(fieldName);

      if(fieldType == double) {

        fieldNamesForSQL += _formattedField + '::float';

      } else if(fieldType == Duration) {

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