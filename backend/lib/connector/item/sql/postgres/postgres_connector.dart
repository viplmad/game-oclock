import 'package:backend/entity/collection_item_entity.dart';
import 'package:postgres/postgres.dart';
import 'package:sql_builder/sql_builder.dart';

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
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({required String tableName, required String relationTable, required String idField, required String joinField, required Map<String, Type> selectFieldsAndTypes, required Map<String, dynamic> whereFieldsAndValues, List<String>? orderFields}) {

    final QueryBuilder queryBuilder = selectRelationQueryBuilder(tableName, relationTable, idField, joinField, selectFieldsAndTypes, whereFieldsAndValues, orderFields);

    return _connection.mappedResultsQuery(
      queryBuilder.toSql(),
      substitutionValues: queryBuilder.buildSubstitutionValues(),
    );

  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({required String primaryTable, required String subordinateTable, required String idField, required String joinField, bool primaryResults = false, required Map<String, Type> selectFieldsAndTypes, required Map<String, dynamic> whereFieldsAndValues, List<String>? orderFields}) {

    final QueryBuilder queryBuilder = selectRelationQueryBuilder(primaryTable, subordinateTable, idField, joinField, selectFieldsAndTypes, whereFieldsAndValues, orderFields, primaryResults: primaryResults);

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
  QueryBuilder insertQueryBuilder(String tableName, Map<String, dynamic> insertFieldsAndValues) {
    final QueryBuilder queryBuilder = FluentQuery
      .insert()
      .into(tableName);

    _buildSet(queryBuilder, insertFieldsAndValues);

    return queryBuilder;
  }

  QueryBuilder selectTableQueryBuilder(String tableName, Map<String, Type> selectFieldsAndTypes, Map<String, dynamic>? whereFieldsAndValues, List<String>? orderFields, int? limit) {
    final QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName);

    _buildFields(queryBuilder, tableName, selectFieldsAndTypes);
    _buildWhere(queryBuilder, tableName, whereFieldsAndValues);
    _buildOrder(queryBuilder, orderFields);
    _buildLimit(queryBuilder, limit);

    return queryBuilder;
  }

  QueryBuilder selectSpecial(String tableName, Map<String, Type> selectFieldsAndTypes, List<String> rawSelects, Map<String, dynamic>? whereFieldsAndValues, List<String>? orderFields) {
    final QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName);

    _buildFields(queryBuilder, tableName, selectFieldsAndTypes);
    rawSelects.forEach((String rawSelect) {
      queryBuilder.fieldRaw(rawSelect);
    });
    _buildWhere(queryBuilder, tableName, whereFieldsAndValues);
    _buildOrder(queryBuilder, orderFields);

    return queryBuilder;
  }

  QueryBuilder selectRelationQueryBuilder(String primaryTable, String subordinateTable, String idField, String joinField, Map<String, Type> selectFieldsAndTypes, Map<String, dynamic> whereFieldsAndValues, List<String>? orderFields, {bool primaryResults = true}) {
    final QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(primaryTable);

    _buildJoin(queryBuilder, subordinateTable, primaryTable, joinField, idField);
    _buildFields(queryBuilder, (primaryResults? primaryTable : subordinateTable), selectFieldsAndTypes);
    _buildWhere(queryBuilder, (primaryResults? subordinateTable : primaryTable), whereFieldsAndValues);
    _buildOrder(queryBuilder, orderFields);

    return queryBuilder;
  }

  QueryBuilder selectJoinQueryBuilder(String leftTable, String rightTable, String leftTableIdField, String rightTableIdField, Map<String, Type> leftSelectFields, Map<String, Type> rightSelectFields, String where, List<String>? orderFields) {
    final QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(leftTable);

    _buildJoin(queryBuilder, rightTable, rightTableIdField, leftTable, leftTableIdField, joinType: JoinType.LEFT);
    _buildFields(queryBuilder, leftTable, leftSelectFields);
    _buildFields(queryBuilder, rightTable, rightSelectFields);
    queryBuilder.whereRaw(where);
    _buildOrder(queryBuilder, orderFields);

    return queryBuilder;
  }

  QueryBuilder selectLikeQueryBuilder(String tableName, Map<String, Type> selectFieldsAndTypes, String searchField, String query, int limit) {
    final QueryBuilder queryBuilder = FluentQuery
      .select(options: this._queryBuilderOptions)
      .from(tableName);

    _buildFields(queryBuilder, tableName, selectFieldsAndTypes);
    final String sanitizedField = Validator.sanitizeTableDotField(tableName, searchField, this._queryBuilderOptions);
    queryBuilder.whereSafe(sanitizedField, OPERATOR_ILIKE, _searchableQuery(query));
    _buildLimit(queryBuilder, limit);

    return queryBuilder;
  }

  QueryBuilder updateQueryBuilder(String tableName, Map<String, dynamic> setFieldsAndValues, Map<String, dynamic> whereFieldsAndValues) {
    final QueryBuilder queryBuilder = FluentQuery
      .update(options: this._queryBuilderOptions)
      .table(tableName);

    _buildSet(queryBuilder, setFieldsAndValues);
    _buildWhere(queryBuilder, null, whereFieldsAndValues);

    return queryBuilder;
  }

  QueryBuilder deleteQueryBuilder(String tableName, Map<String, dynamic> whereFieldsAndValues) {
    final QueryBuilder queryBuilder = FluentQuery
      .delete(options: this._queryBuilderOptions)
      .from(tableName);

    _buildWhere(queryBuilder, null, whereFieldsAndValues);

    return queryBuilder;
  }
  //#endregion Query Builders

  //#region Helpers
  void _buildJoin(QueryBuilder queryBuilder, String joinTableName, String primaryTableName, String joinField, String primaryField, {JoinType joinType = JoinType.INNER}) {
    final String onPrimary = Validator.sanitizeTableDotField(primaryTableName, primaryField, this._queryBuilderOptions);
    final String onJoin = Validator.sanitizeTableDotField(joinTableName, joinField, this._queryBuilderOptions);
    queryBuilder.join(joinTableName, '$onPrimary = $onJoin', type: joinType);
  }

  void _buildFields(QueryBuilder queryBuilder, String? tableName, Map<String, Type>? selectFieldsAndTypes) {
    if(selectFieldsAndTypes != null) {
      selectFieldsAndTypes.forEach( (String fieldName, Type fieldType) {

        final String sanitizedField = Validator.sanitizeTableDotField(tableName, fieldName, this._queryBuilderOptions);

        if(fieldType == double) {

          final String rawDoubleField = sanitizedField + '::float';
          queryBuilder.fieldRaw(rawDoubleField);

        } else if(fieldType == Duration) {

          final String fieldValue = Validator.sanitizeField(fieldName.trim(), this._queryBuilderOptions);
          final String rawDurationField = '(Extract(hours from ' + sanitizedField + ') * 60 + EXTRACT(minutes from ' + sanitizedField + '))::int AS ' + fieldValue;
          queryBuilder.fieldRaw(rawDurationField);

        } else {

          queryBuilder.fieldRaw(sanitizedField);

        }

      });
    }
  }

  void _buildWhere(QueryBuilder queryBuilder, String? tableName, Map<String, dynamic>? whereFieldsAndValues) {
    if(whereFieldsAndValues != null) {
      whereFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

        // Revise fields and values map to take into account special cases not covered by postgres connector (mainly Duration)
        if(fieldValue == null) {
          fieldValue = 'NULL';
        } else if(fieldValue is Duration) {
          fieldValue = fieldValue.inSeconds;
        }

        final String sanitizedField = Validator.sanitizeTableDotField(tableName, fieldName, this._queryBuilderOptions);
        queryBuilder.whereSafe(sanitizedField, OPERATOR_EQ, fieldValue);

      });
    }
  }

  void _buildSet(QueryBuilder queryBuilder, Map<String, dynamic>? setFieldsAndValues) {
    if(setFieldsAndValues != null) {
      setFieldsAndValues.forEach( (String fieldName, dynamic fieldValue) {

        if(fieldValue == null) {
          fieldValue = 'NULL';
        } else if(fieldValue is Duration) {
          fieldValue = fieldValue.inSeconds;
        }

        queryBuilder.set(fieldName, fieldValue);

      });
    }
  }

  void _buildOrder(QueryBuilder queryBuilder, List<String>? orderFields) {
    if(orderFields != null) {
      for(final String field in orderFields) {
        queryBuilder.order(field);
      }
    }
  }

  void _buildLimit(QueryBuilder queryBuilder, int? limit) {
    if(limit != null) {
      queryBuilder.limit(limit);
    }
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