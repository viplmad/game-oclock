import 'package:game_collection/connector/item/sql/builder/block.dart';

import 'distinct_block.dart';
import 'from_table_block.dart';
import 'get_field_block.dart';
import 'group_by_block.dart';
import 'join_block.dart';
import 'limit_block.dart';
import 'sort_order.dart';
import 'union_block.dart';
import 'union_type.dart';
import 'where_block.dart';
import 'offset_block.dart';
import 'order_by_block.dart';
import 'string_block.dart';
import 'query_builder.dart';
import 'query_builder_options.dart';
import 'join_type.dart';
import 'expression.dart';

/// SELECT query builder.
class Select extends QueryBuilder {
  Select(
    QueryBuilderOptions? options,
  ) : super(
          options,
          <Block>[
            StringBlock(options, 'SELECT'),
            DistinctBlock(options), // 1
            GetFieldBlock(options), // 2
            FromTableBlock(options), // 3
            JoinBlock(options), // 4
            WhereBlock(options), // 5
            GroupByBlock(options), // 6
            OrderByBlock(options), // 7
            LimitBlock(options), // 8
            OffsetBlock(options), // 9
            UnionBlock(options), // 10
          ],
        );

  //
  // DISTINCT
  //
  @override
  QueryBuilder distinct() {
    final DistinctBlock block = blocks[1] as DistinctBlock;
    block.setDistinct();
    return this;
  }

  //
  // FROM
  //
  @override
  QueryBuilder from(String table, {String? alias}) {
    final FromTableBlock block = blocks[3] as FromTableBlock;
    block.setFrom(table, alias);
    return this;
  }

  @override
  QueryBuilder fromSubQuery(QueryBuilder table, {String? alias}) {
    final FromTableBlock block = blocks[3] as FromTableBlock;
    block.setFromSubQuery(table, alias);
    return this;
  }

  @override
  QueryBuilder fromRaw(String fromRawSqlString) {
    final FromTableBlock block = blocks[3] as FromTableBlock;
    block.setFromRaw(fromRawSqlString);
    return this;
  }

  //
  // GET
  //
  @override
  QueryBuilder field(String field, {String? alias, String? tableName}) {
    final GetFieldBlock block = blocks[2] as GetFieldBlock;
    block.setField(field, alias, tableName);
    return this;
  }

  @override
  QueryBuilder fieldSubQuery(QueryBuilder field, {String? alias}) {
    final GetFieldBlock block = blocks[2] as GetFieldBlock;
    block.setFieldFromSubQuery(field, alias);
    return this;
  }

  @override
  QueryBuilder fields(Iterable<String> fields, {String? tableName}) {
    final GetFieldBlock block = blocks[2] as GetFieldBlock;
    block.setFields(fields, tableName);
    return this;
  }

  @override
  QueryBuilder fieldRaw(String setFieldRawSql) {
    final GetFieldBlock block = blocks[2] as GetFieldBlock;
    block.setFieldRaw(setFieldRawSql);
    return this;
  }

  @override
  QueryBuilder group(String field) {
    final GroupByBlock block = blocks[6] as GroupByBlock;
    block.setGroup(field);
    return this;
  }

  @override
  QueryBuilder groups(Iterable<String> fields) {
    final GroupByBlock block = blocks[6] as GroupByBlock;
    block.setGroups(fields);
    return this;
  }

  @override
  QueryBuilder groupRaw(String groupRawSql) {
    final GroupByBlock block = blocks[6] as GroupByBlock;
    block.setGroupRaw(groupRawSql);
    return this;
  }

  //
  // JOIN
  //
  @override
  QueryBuilder join(String joinTableName, String condition, {String? alias, JoinType type = JoinType.INNER}) {
    final JoinBlock block = blocks[4] as JoinBlock;
    block.setJoin(joinTableName, alias, condition, type);
    return this;
  }

  @override
  QueryBuilder joinWithSubQuery(QueryBuilder table, String condition, {String? alias, JoinType type = JoinType.INNER}) {
    final JoinBlock block = blocks[4] as JoinBlock;
    block.setJoinWithSubQuery(table, alias, condition, type);
    return this;
  }

  @override
  QueryBuilder joinWithExpression(String table, Expression condition, {String? alias, JoinType type = JoinType.INNER}) {
    final JoinBlock block = blocks[4] as JoinBlock;
    block.setJoinWithExpression(table, alias, condition, type);
    return this;
  }

  @override
  QueryBuilder joinWithQueryExpr(QueryBuilder table, Expression condition,
      {String? alias, JoinType type = JoinType.INNER}) {
    final JoinBlock block = blocks[4] as JoinBlock;
    block.setJoinWithQueryWithExpr(table, alias, condition, type);
    return this;
  }

  //
  // WHERE
  //

  @override
  QueryBuilder where(String condition, [Object? param, String andOr = 'AND']) {
    final WhereBlock block = blocks[5] as WhereBlock;
    block.setWhere(condition, param, andOr);
    return this;
  }

  @override
  QueryBuilder whereExpr(Expression condition, [Object? param, String andOr = 'AND']) {
    final WhereBlock block = blocks[5] as WhereBlock;
    block.setWhereWithExpression(condition, param);
    return this;
  }

  @override
  QueryBuilder whereRaw(String whereRawSql, [String andOr = 'AND']) {
    final WhereBlock block = blocks[5] as WhereBlock;
    block.setWhereRaw(whereRawSql, andOr);
    return this;
  }

  @override
  QueryBuilder whereSafe(String field, String operator, dynamic value) {
    final WhereBlock block = blocks[5] as WhereBlock;
    block.setWhereSafe(field, operator, value);
    return this;
  }

  @override
  QueryBuilder orWhereSafe(String field, String operator, dynamic value) {
    final WhereBlock block = blocks[5] as WhereBlock;
    block.setOrWhereSafe(field, operator, value);
    return this;
  }

  @override
  QueryBuilder whereGroup(QueryBuilder Function(QueryBuilder) function) {
    final WhereBlock block = blocks[5] as WhereBlock;
    block.setStartGroup();
    final QueryBuilder r = function(this);
    block.setEndGroup();
    return r;
  }

  @override
  QueryBuilder orWhereGroup(QueryBuilder Function(QueryBuilder) function) {
    final WhereBlock block = blocks[5] as WhereBlock;
    block.setStartGroup();
    final QueryBuilder r = function(this);
    block.setEndGroup();
    return r;
  }

  //
  // LIMIT
  //
  @override
  QueryBuilder limit(int value) {
    final LimitBlock block = blocks[8] as LimitBlock;
    block.setLimit(value);
    return this;
  }

  //
  // ORDER BY
  //
  @override
  QueryBuilder order(String field, {SortOrder dir = SortOrder.ASC}) {
    final OrderByBlock block = blocks[7] as OrderByBlock;
    block.setOrder(field, dir);
    return this;
  }

  //
  // OFFSET
  //
  @override
  QueryBuilder offset(int value) {
    final OffsetBlock block = blocks[9] as OffsetBlock;
    block.setOffset(value);
    return this;
  }

  //
  // UNION
  //
  @override
  QueryBuilder union(String table, UnionType unionType) {
    final UnionBlock block = blocks[10] as UnionBlock;
    block.setUnion(table, unionType);
    return this;
  }

  @override
  QueryBuilder unionSubQuery(QueryBuilder table, UnionType unionType) {
    final UnionBlock block = blocks[10] as UnionBlock;
    block.setUnionSubQuery(table, unionType);
    return this;
  }
}
