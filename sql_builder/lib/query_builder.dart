import 'from_table_block.dart';

import 'expression.dart';
import 'join_type.dart';
import 'query_builder_options.dart';
import 'block.dart';
import 'sort_order.dart';
import 'union_type.dart';
import 'util.dart';
import 'exceptions.dart';

abstract class QueryBuilder {
  QueryBuilder(
    QueryBuilderOptions? options,
    List<Block>? blocks,
  ) {
    this.options = options ?? QueryBuilderOptions();
    this.blocks = blocks ?? <Block>[];
  }
  late QueryBuilderOptions options;
  late List<Block> blocks;

  bool isQuery() {
    if (blocks.isEmpty) {
      return false;
    }
    return true;
  }

  bool isContainFromBlock() {
    if (blocks.isEmpty) {
      return false;
    }
    bool isFromBlock = false;
    for (final Block blk in blocks) {
      if (blk is FromTableBlock) {
        isFromBlock = true;
      }
    }
    return isFromBlock;
  }

  @override
  String toString() {
    final List<String> results = <String>[];
    for (final Block block in blocks) {
      results.add(block.buildStr(this));
    }

    return Util.joinNonEmpty(options.separator, results);
  }

  ///isFirst used to add or replace limit 1 offset 0 in query string
  String toSql({bool isFirst = false, bool isCount = false}) {
    final List<String> results = <String>[];
    for (final Block block in blocks) {
      results.add(block.buildStr(this));
    }
    String result = Util.joinNonEmpty(options.separator, results);

    if (isFirst) {
      final int idx = result.lastIndexOf(RegExp(r'LIMIT', caseSensitive: false));
      if (idx != -1) {
        result = result.substring(0, idx - 1);
      }
      final int idx2 = result.lastIndexOf(RegExp(r'OFFSET', caseSensitive: false));
      if (idx2 != -1) {
        result = result.substring(0, idx2 - 1);
      }
      result = '$result LIMIT 1 OFFSET 0';
    }

    if (isCount) {
      final int fromIdx = result.lastIndexOf(RegExp(r'FROM', caseSensitive: false));
      if (fromIdx != -1) {
        result = result.substring(fromIdx, result.length);
        result = 'SELECT COUNT(*) as total_records $result';
      }
    }

    return result;
  }

  Map<String, dynamic> buildSubstitutionValues() {
    final Map<String, dynamic> result = <String, dynamic>{};
    for (final Block block in blocks) {
      result.addAll(block.buildSubstitutionValues());
    }
    return result;
  }

  List<String> buildReturningFields() {
    final List<String> result = <String>[];
    for (final Block block in blocks) {
      final List<String>? fields = block.buildReturningFields();
      if (fields != null) {
        result.addAll(fields);
      }
    }
    return result;
  }

  //
  // DISTINCT
  //
  QueryBuilder distinct() {
    throw UnsupportedOperationException('`distinct` not implemented');
  }

  //
  // FROM
  //
  QueryBuilder from(String table, {String? alias}) {
    throw UnsupportedOperationException('`from` not implemented');
  }

  QueryBuilder fromRaw(String fromRawSqlString) {
    throw UnsupportedOperationException('`fromRaw` not implemented');
  }

  QueryBuilder fromSubQuery(QueryBuilder table, {String? alias}) {
    throw UnsupportedOperationException('`fromSubQuery` not implemented');
  }

  //
  // GET FIELDS
  //
  QueryBuilder field(String field, {String? alias, String? tableName}) {
    throw UnsupportedOperationException('`fieldWithAlias` not implemented');
  }

  QueryBuilder fieldSubQuery(QueryBuilder field, {String? alias}) {
    throw UnsupportedOperationException('`fieldSubQueryWithAlias` not implemented');
  }

  QueryBuilder fields(Iterable<String> fields, {String? tableName}) {
    throw UnsupportedOperationException('`fields` not implemented');
  }

  QueryBuilder fieldRaw(String setFieldRawSql) {
    throw UnsupportedOperationException('`fieldRaw` not implemented');
  }

  //
  // GROUP
  //
  QueryBuilder group(String field) {
    throw UnsupportedOperationException('`group` not implemented');
  }

  QueryBuilder groups(Iterable<String> fields) {
    throw UnsupportedOperationException('`groups` not implemented');
  }

  QueryBuilder groupRaw(String groupRawSql) {
    throw UnsupportedOperationException('`groupRaw` not implemented');
  }

  //
  // JOIN
  //
  QueryBuilder joinRaw(String sql) {
    throw UnsupportedOperationException('`joinRaw` not implemented');
  }

  QueryBuilder join(String joinTableName, String condition, {String? alias, JoinType type = JoinType.INNER}) {
    throw UnsupportedOperationException('`join` not implemented');
  }

  QueryBuilder innerJoin(String joinTableName, String field1, String operator, String field2, {String? alias}) {
    return join(joinTableName, field1 + operator + field2, type: JoinType.INNER, alias: alias);
  }

  QueryBuilder leftJoin(String joinTableName, String field1, String operator, String field2, {String? alias}) {
    return join(joinTableName, field1 + operator + field2, type: JoinType.LEFT, alias: alias);
  }

  QueryBuilder rightJoin(String joinTableName, String field1, String operator, String field2, {String? alias}) {
    return join(joinTableName, field1 + operator + field2, type: JoinType.RIGHT, alias: alias);
  }

  QueryBuilder joinWithSubQuery(QueryBuilder table, String condition, {String? alias, JoinType type = JoinType.INNER}) {
    throw UnsupportedOperationException('`joinWithSubQuery` not implemented');
  }

  QueryBuilder joinWithExpression(String table, Expression condition, {String? alias, JoinType type = JoinType.INNER}) {
    throw UnsupportedOperationException('`joinWithExpression` not implemented');
  }

  QueryBuilder joinWithQueryExpr(QueryBuilder table, Expression condition,
      {String? alias, JoinType type = JoinType.INNER}) {
    throw UnsupportedOperationException('`joinWithQueryExpr` not implemented');
  }

  //
  // WHERE
  //
  QueryBuilder where(String condition, [Object? param, String andOr = 'AND']) {
    throw UnsupportedOperationException('`where` not implemented');
  }

  QueryBuilder whereExpr(Expression condition, [Object? param, String andOr = 'AND']) {
    throw UnsupportedOperationException('`whereExpr` not implemented');
  }

  QueryBuilder whereRaw(String whereRawSql, [String andOr = 'AND']) {
    throw UnsupportedOperationException('`whereRaw` not implemented');
  }

  ///add a andWhere safe way against SQL injection
  QueryBuilder whereSafe(String field, String operator, dynamic value) {
    throw UnsupportedOperationException('`whereSafe` not implemented');
  }

  ///add a orWhere safe way against SQL injection
  QueryBuilder orWhereSafe(String field, String operator, dynamic value) {
    throw UnsupportedOperationException('`orWhereSafe` not implemented');
  }

  //Future<List<T>> Function<T>([T Function(Map<String, dynamic>) factory])
  QueryBuilder whereGroup(QueryBuilder Function(QueryBuilder) function) {
    throw UnsupportedOperationException('`whereGroup` not implemented');
  }

  QueryBuilder orWhereGroup(QueryBuilder Function(QueryBuilder) function) {
    throw UnsupportedOperationException('`orWhereGroup` not implemented');
  }

  //
  // LIMIT
  //
  QueryBuilder limit(int value) {
    throw UnsupportedOperationException('`limit` not implemented');
  }

  //
  // ORDER BY
  //
  QueryBuilder order(String field, {SortOrder dir = SortOrder.ASC}) {
    throw UnsupportedOperationException('`order` not implemented');
  }

  //
  // OFFSET
  //
  QueryBuilder offset(int value) {
    throw UnsupportedOperationException('`offset` not implemented');
  }

  //
  // UNION
  //
  QueryBuilder union(String table, UnionType unionType) {
    throw UnsupportedOperationException('union not implemented');
  }

  QueryBuilder unionSubQuery(QueryBuilder table, UnionType unionType) {
    throw UnsupportedOperationException('unionSubQuery not implemented');
  }

  //
  // TABLE
  //
  QueryBuilder table(String table, {String? alias}) {
    throw UnsupportedOperationException('`table` not implemented');
  }

  //
  // SET
  //
  QueryBuilder set(String field, dynamic value) {
    throw UnsupportedOperationException('`set` not implemented');
  }

  QueryBuilder setAll(Map<String, dynamic> fieldsAndValues) {
    throw UnsupportedOperationException('`setAll` not implemented');
  }

  //
  // INTO
  //
  QueryBuilder into(String table) {
    throw UnsupportedOperationException('`into` not implemented');
  }

  //
  // `FROM QUERY`
  //
  QueryBuilder fromQuery(Iterable<String> fields, QueryBuilder query) {
    throw UnsupportedOperationException('`fromQuery` not implemented');
  }
}
