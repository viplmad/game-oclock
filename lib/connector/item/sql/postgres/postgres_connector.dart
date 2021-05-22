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

  static const String OPERATOR_EQ = '=';
  static const String OPERATOR_ILIKE = 'ILIKE';

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
  Future<List<Map<String, Map<String, dynamic>>>> insertRecord({required String tableName, required Map<String, dynamic> fieldsAndValues, String? idField}) {

    fieldsAndValues = _reviseFieldsAndValues(fieldsAndValues);

    final QueryBuilder queryBuilder = FluentQuery
      .insert()
      .into(tableName)
      .setAll(fieldsAndValues);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql() + (idField != null? ' RETURNING ' + _forceDoubleQuotes(idField) : ''),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTable({required String tableName, required Map<String, Type> selectFieldsAndTypes, Map<String, dynamic>? whereFieldsAndValues, List<String>? orderFields, int? limit}) {

    final List<String> fields = _reviseFieldsAndTypes(selectFieldsAndTypes);

    QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName)
      .fields(fields);

    if(whereFieldsAndValues != null) {
      whereFieldsAndValues = _reviseFieldsAndValues(whereFieldsAndValues);
      whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

        queryBuilder = queryBuilder.whereSafe(fieldName, OPERATOR_EQ, fieldValue);

      });
    }

    if(orderFields != null) {
      for(final String field in orderFields) {
        queryBuilder = queryBuilder.order(field);
      }
    }

    if(limit != null) {
      queryBuilder = queryBuilder.limit(limit);
    }

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readJoinTable({required String leftTable, required String rightTable, required String leftTableIdField, required String rightTableIdField, required Map<String, Type> leftSelectFields, required Map<String, Type> rightSelectFields, required String where, List<String>? orderFields}) {

    final List<String> leftFields = _reviseFieldsAndTypes(leftSelectFields);
    final List<String> rightFields = _reviseFieldsAndTypes(rightSelectFields);

    QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(leftTable)
      .join(rightTable, '$leftTableIdField = $rightTableIdField', type: JoinType.LEFT)
      .fields(leftFields, tableName: leftTable)
      .fields(rightFields, tableName: rightTable)
      .whereRaw(where);

    if(orderFields != null) {
      for(final String field in orderFields) {
        queryBuilder = queryBuilder.order(field);
      }
    }

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String tableName, required String relationTable, required String joinField, required String relationField, required int relationId, required Map<String, Type> selectFieldsAndTypes, List<String>? orderFields}) {

    final List<String> fields = _reviseFieldsAndTypes(selectFieldsAndTypes);

    QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName)
      .join(relationTable, '$joinField = $relationField')
      .fields(fields)
      .whereSafe(relationField, OPERATOR_EQ, relationId);

    if(orderFields != null) {
      for(final String field in orderFields) {
        queryBuilder = queryBuilder.order(field);
      }
    }

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String relationField, required int relationId, bool primaryResults = false, required Map<String, Type> selectFieldsAndTypes, List<String>? orderFields}) {

    final List<String> fields = _reviseFieldsAndTypes(selectFieldsAndTypes);

    QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(subordinateTable)
      .join(primaryTable, '$subordinateTable.$relationField = $primaryTable.$idField')
      .fields(fields, tableName: (primaryResults? primaryTable : subordinateTable))
      .whereSafe((primaryResults? subordinateTable : primaryTable) + '.' + _forceDoubleQuotes(idField), OPERATOR_EQ, relationId);

    if(orderFields != null) {
      for(final String field in orderFields) {
        queryBuilder = queryBuilder.order(field);
      }
    }

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({required String tableName, required Map<String, Type> selectFieldsAndTypes, required String searchField, required String query, required int limit}) {

    final List<String> fields = _reviseFieldsAndTypes(selectFieldsAndTypes);

    final QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName)
      .fields(fields)
      .whereSafe(searchField, OPERATOR_ILIKE, _searchableQuery(query))
      .limit(limit);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<dynamic> updateTable<T>({required String tableName, required Map<String, dynamic> setFieldsAndValues, required Map<String, dynamic> whereFieldsAndValues}) {

    setFieldsAndValues = _reviseFieldsAndValues(setFieldsAndValues); // TODO check it makes nulls

    QueryBuilder queryBuilder = FluentQuery
      .update()
      .into(tableName)
      .setAll(setFieldsAndValues);

    whereFieldsAndValues = _reviseFieldsAndValues(whereFieldsAndValues);
    whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

      queryBuilder = queryBuilder.whereSafe(fieldName, OPERATOR_EQ, fieldValue);

    });

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteRecord({required String tableName, required Map<String, dynamic> whereFieldsAndValues}) {

    QueryBuilder queryBuilder = FluentQuery
      .delete()
      .from(tableName);

    whereFieldsAndValues = _reviseFieldsAndValues(whereFieldsAndValues);
    whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

      queryBuilder = queryBuilder.whereSafe(fieldName, OPERATOR_EQ, fieldValue);

    });

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion DELETE


  //#region Helpers
  /// Revise fields and values map to take into account special cases not covered by postgres connector (mainly Duration)
  Map<String, dynamic> _reviseFieldsAndValues(Map<String, dynamic> fieldsAndValues) {

    fieldsAndValues.forEach( (String fieldName, dynamic value) {

      if(value is Duration) {
        fieldsAndValues[fieldName] = value.inSeconds;
      }

    });

    return fieldsAndValues;

  }

  List<String> _reviseFieldsAndTypes(Map<String, Type> fieldsAndTypes) {

    final List<String> fields = <String>[];
    fieldsAndTypes.forEach( (String fieldName, Type fieldType) {

      final String escapedField = _forceDoubleQuotes(fieldName);

      String formattedField = escapedField;
      if(fieldType == double) {

        formattedField += escapedField + '::float';

      } else if(fieldType == Duration) {

        formattedField += '(Extract(hours from ' + escapedField + ') * 60 + EXTRACT(minutes from ' + escapedField + '))::int AS ' + _forceDoubleQuotes(fieldName);

      }

      fields.add(formattedField);

    });

    return fields;

  }

  dynamic _reviseValue(dynamic fieldValue) {
    dynamic value;

    if(fieldValue == null) {
      value = 'NULL';
    } else {
      value = fieldValue;
    }

    return value;
  }

  String _searchableQuery(String query) {

    return '%' + query + '%';

  }

  String _forceDoubleQuotes(String text) {

    return '\"' + text + '\"';

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