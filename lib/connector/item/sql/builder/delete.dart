import 'block.dart';
import 'sort_order.dart';

import 'expression.dart';
import 'join_type.dart';
import 'query_builder.dart';
import 'query_builder_options.dart';
import 'delete_block.dart';
import 'from_table_block.dart';
import 'join_block.dart';
import 'where_block.dart';
import 'order_by_block.dart';
import 'limit_block.dart';

/// DELETE query builder.
class Delete extends QueryBuilder {
  Delete(
    QueryBuilderOptions? options,
  ) : super(
          options,
          <Block>[
            DeleteBlock(options),
            FromTableBlock(options), // 1
            JoinBlock(options), // 2
            WhereBlock(options), // 3
            OrderByBlock(options), // 4
            LimitBlock(options) // 5
          ],
        );

  @override
  QueryBuilder from(String table, {String? alias}) {
    final FromTableBlock block = blocks[1] as FromTableBlock;
    block.setFrom(table, alias);
    return this;
  }

  @override
  QueryBuilder where(String condition, [Object? param, String andOr = 'AND']) {
    final WhereBlock block = blocks[3] as WhereBlock;
    block.setWhere(condition, param, andOr);
    return this;
  }

  @override
  QueryBuilder whereExpr(Expression condition,
      [Object? param, String andOr = 'AND']) {
    final WhereBlock block = blocks[3] as WhereBlock;
    block.setWhereWithExpression(condition, param);
    return this;
  }

  @override
  QueryBuilder whereRaw(String whereRawSql, [String andOr = 'AND']) {
    final WhereBlock block = blocks[3] as WhereBlock;
    block.setWhereRaw(whereRawSql, andOr);
    return this;
  }

  @override
  QueryBuilder whereSafe(String field, String operator, dynamic value) {
    final WhereBlock block = blocks[3] as WhereBlock;
    block.setWhereSafe(field, operator, value);
    return this;
  }

  @override
  QueryBuilder orWhereSafe(String field, String operator, dynamic value) {
    final WhereBlock block = blocks[3] as WhereBlock;
    block.setOrWhereSafe(field, operator, value);
    return this;
  }

  @override
  QueryBuilder join(String joinTableName, String condition,
      {String? alias, JoinType type = JoinType.INNER}) {
    final JoinBlock block = blocks[2] as JoinBlock;
    block.setJoin(joinTableName, alias, condition, type);
    return this;
  }

  @override
  QueryBuilder joinWithSubQuery(QueryBuilder table, String condition,
      {String? alias, JoinType type = JoinType.INNER}) {
    final JoinBlock block = blocks[2] as JoinBlock;
    block.setJoinWithSubQuery(table, alias, condition, type);
    return this;
  }

  @override
  QueryBuilder joinWithExpression(String table, Expression condition,
      {String? alias, JoinType type = JoinType.INNER}) {
    final JoinBlock block = blocks[2] as JoinBlock;
    block.setJoinWithExpression(table, alias, condition, type);
    return this;
  }

  @override
  QueryBuilder joinWithQueryExpr(QueryBuilder table, Expression condition,
      {String? alias, JoinType type = JoinType.INNER}) {
    final JoinBlock block = blocks[2] as JoinBlock;
    block.setJoinWithQueryWithExpr(table, alias, condition, type);
    return this;
  }

  @override
  QueryBuilder order(String field, {SortOrder dir = SortOrder.ASC}) {
    final OrderByBlock block = blocks[4] as OrderByBlock;
    block.setOrder(field, dir);
    return this;
  }

  @override
  QueryBuilder limit(int value) {
    final LimitBlock block = blocks[5] as LimitBlock;
    block.setLimit(value);
    return this;
  }
}
