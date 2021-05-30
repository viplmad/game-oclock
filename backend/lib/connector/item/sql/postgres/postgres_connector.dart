import 'package:postgres/postgres.dart';
import 'package:sql_builder/sql_builder.dart';

import 'package:backend/entity/entity.dart';

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

    final QueryBuilder queryBuilder = insertQueryBuilder(tableName, fieldsAndValues);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql() + (idField != null? ' RETURNING ' + Validator.sanitizeTableDotField(tableName, idField, this._queryBuilderOptions) : ''),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion CREATE

  //#region READ
  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTable({required String tableName, required Map<String, Type> selectFieldsAndTypes, Map<String, dynamic>? whereFieldsAndValues, List<String>? orderFields, int? limit}) {

    final QueryBuilder queryBuilder = selectTableQueryBuilder(tableName, selectFieldsAndTypes, whereFieldsAndValues, orderFields, limit);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readJoinTable({required String leftTable, required String rightTable, required String leftTableIdField, required String rightTableIdField, required Map<String, Type> leftSelectFields, required Map<String, Type> rightSelectFields, required String where, List<String>? orderFields}) {

    final QueryBuilder queryBuilder = selectJoinQueryBuilder(leftTable, rightTable, leftTableIdField, rightTableIdField, leftSelectFields, rightSelectFields, where, orderFields);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String tableName, required String relationTable, required String joinField, required String relationField, required int relationId, required Map<String, Type> selectFieldsAndTypes, List<String>? orderFields}) {

    final QueryBuilder queryBuilder = selectRelationQueryBuilder(tableName, relationTable, joinField, relationField, relationId, selectFieldsAndTypes, orderFields);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String relationField, required int relationId, bool primaryResults = false, required Map<String, Type> selectFieldsAndTypes, List<String>? orderFields}) {

    final QueryBuilder queryBuilder = selectWeakRelationQueryBuilder(primaryTable, subordinateTable, relationField, relationId, primaryResults, selectFieldsAndTypes, orderFields);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({required String tableName, required Map<String, Type> selectFieldsAndTypes, required String searchField, required String query, required int limit}) {

    final QueryBuilder queryBuilder = selectLikeQueryBuilder(tableName, selectFieldsAndTypes, searchField, query, limit);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion READ

  //#region UPDATE
  @override
  Future<dynamic> updateTable<T>({required String tableName, required Map<String, dynamic> setFieldsAndValues, required Map<String, dynamic> whereFieldsAndValues}) {

    final QueryBuilder queryBuilder = updateQueryBuilder(tableName, setFieldsAndValues, whereFieldsAndValues);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion UPDATE

  //#region DELETE
  @override
  Future<dynamic> deleteRecord({required String tableName, required Map<String, dynamic> whereFieldsAndValues}) {

    final QueryBuilder queryBuilder = deleteQueryBuilder(tableName, whereFieldsAndValues);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }
  //#endregion DELETE

  //#region Query Builders
  QueryBuilder insertQueryBuilder(String tableName, Map<String, dynamic> fieldsAndValues) {
    fieldsAndValues = _reviseFieldsAndValues(fieldsAndValues);

    final QueryBuilder queryBuilder = FluentQuery
      .insert()
      .into(tableName)
      .setAll(fieldsAndValues);
    return queryBuilder;
  }

  QueryBuilder selectTableQueryBuilder(String tableName, Map<String, Type> selectFieldsAndTypes, Map<String, dynamic>? whereFieldsAndValues, List<String>? orderFields, int? limit) {
    QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName);

    _buildFieldsFromMap(queryBuilder, tableName, selectFieldsAndTypes);

    if(whereFieldsAndValues != null) {
      whereFieldsAndValues = _reviseFieldsAndValues(whereFieldsAndValues);
      whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

        final String sanitizedField = Validator.sanitizeTableDotField(tableName, fieldName, this._queryBuilderOptions);
        queryBuilder = queryBuilder.whereSafe(sanitizedField, OPERATOR_EQ, fieldValue);

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
    return queryBuilder;
  }

  QueryBuilder selectJoinQueryBuilder(String leftTable, String rightTable, String leftTableIdField, String rightTableIdField, Map<String, Type> leftSelectFields, Map<String, Type> rightSelectFields, String where, List<String>? orderFields) {

    QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(leftTable)
      .join(rightTable, '$leftTableIdField = $rightTableIdField', type: JoinType.LEFT);

    _buildFieldsFromMap(queryBuilder, leftTable, leftSelectFields);
    _buildFieldsFromMap(queryBuilder, rightTable, rightSelectFields);

    queryBuilder.whereRaw(where);

    if(orderFields != null) {
      for(final String field in orderFields) {
        queryBuilder = queryBuilder.order(field);
      }
    }
    return queryBuilder;
  }

  QueryBuilder selectRelationQueryBuilder(String tableName, String relationTable, String joinField, String relationField, int relationId, Map<String, Type> selectFieldsAndTypes, List<String>? orderFields) {

    QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName);

    final String onTable = Validator.sanitizeTableDotField(tableName, idField, this._queryBuilderOptions);
    final String onRelation = Validator.sanitizeTableDotField(relationTable, joinField, this._queryBuilderOptions);
    queryBuilder.join(relationTable, '$onTable = $onRelation');

    _buildFieldsFromMap(queryBuilder, tableName, selectFieldsAndTypes);

    final String sanitizedWhere = Validator.sanitizeTableDotField(relationTable, relationField, this._queryBuilderOptions);
    queryBuilder.whereSafe(sanitizedWhere, OPERATOR_EQ, relationId);

    if(orderFields != null) {
      for(final String field in orderFields) {
        queryBuilder = queryBuilder.order(field);
      }
    }
    return queryBuilder;
  }

  QueryBuilder selectWeakRelationQueryBuilder(String primaryTable, String subordinateTable, String relationField, int relationId, bool primaryResults, Map<String, Type> selectFieldsAndTypes, List<String>? orderFields) {

    QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(subordinateTable);

    final String onSubordinate = Validator.sanitizeTableDotField(subordinateTable, relationField, this._queryBuilderOptions);
    final String onPrimary = Validator.sanitizeTableDotField(primaryTable, idField, this._queryBuilderOptions);
    queryBuilder.join(primaryTable, '$onSubordinate = $onPrimary');

    _buildFieldsFromMap(queryBuilder, (primaryResults? primaryTable : subordinateTable), selectFieldsAndTypes);

    final String sanitizedWhere = Validator.sanitizeTableDotField((primaryResults? subordinateTable : primaryTable), idField, this._queryBuilderOptions);
    queryBuilder.whereSafe(sanitizedWhere, OPERATOR_EQ, relationId);

    if(orderFields != null) {
      for(final String field in orderFields) {
        queryBuilder = queryBuilder.order(field);
      }
    }
    return queryBuilder;
  }

  QueryBuilder selectLikeQueryBuilder(String tableName, Map<String, Type> selectFieldsAndTypes, String searchField, String query, int limit) {

    final QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName);

    _buildFieldsFromMap(queryBuilder, tableName, selectFieldsAndTypes);

    queryBuilder
      .whereSafe(searchField, OPERATOR_ILIKE, _searchableQuery(query))
      .limit(limit);
    return queryBuilder;
  }

  QueryBuilder updateQueryBuilder(String tableName, Map<String, dynamic> setFieldsAndValues, Map<String, dynamic> whereFieldsAndValues) {
    setFieldsAndValues = _reviseFieldsAndValues(setFieldsAndValues); // TODO check it makes nulls

    QueryBuilder queryBuilder = FluentQuery
      .update()
      .into(tableName)
      .setAll(setFieldsAndValues);

    whereFieldsAndValues = _reviseFieldsAndValues(whereFieldsAndValues);
    whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

      queryBuilder = queryBuilder.whereSafe(fieldName, OPERATOR_EQ, fieldValue);

    });
    return queryBuilder;
  }

  QueryBuilder deleteQueryBuilder(String tableName, Map<String, dynamic> whereFieldsAndValues) {
    QueryBuilder queryBuilder = FluentQuery
      .delete()
      .from(tableName);

    whereFieldsAndValues = _reviseFieldsAndValues(whereFieldsAndValues);
    whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

      queryBuilder = queryBuilder.whereSafe(fieldName, OPERATOR_EQ, fieldValue);

    });
    return queryBuilder;
  }
  //#endregion Query Builders

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

  void _buildFieldsFromMap(QueryBuilder queryBuilder, String tableName, Map<String, Type> fieldsAndTypes) {

    fieldsAndTypes.forEach( (String fieldName, Type fieldType) {

      if(fieldType == double) {

        final String sanitizedField = Validator.sanitizeTableDotField(tableName, fieldName, this._queryBuilderOptions);
        final String rawDoubleField = sanitizedField + '::float';
        queryBuilder.fieldRaw(rawDoubleField);

      } else if(fieldType == Duration) {

        final String sanitizedField = Validator.sanitizeTableDotField(tableName, fieldName, this._queryBuilderOptions);
        final String fieldValue = Validator.sanitizeField(fieldName.trim(), this._queryBuilderOptions);
        final String rawDurationField = '(Extract(hours from ' + sanitizedField + ') * 60 + EXTRACT(minutes from ' + sanitizedField + '))::int AS ' + fieldValue;
        queryBuilder.fieldRaw(rawDurationField);

      } else {

        queryBuilder.field(fieldName, tableName: tableName);

      }

    });

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