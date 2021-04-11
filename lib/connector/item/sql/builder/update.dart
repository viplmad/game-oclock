import 'block.dart';
import 'sort_order.dart';

import 'expression.dart';
import 'query_builder_options.dart';

import 'query_builder.dart';
import 'string_block.dart';
import 'update_table_block.dart';
import 'set_field_block.dart';
import 'where_block.dart';
import 'order_by_block.dart';
import 'limit_block.dart';

/// UPDATE query builder.
class Update extends QueryBuilder {
  Update(
    QueryBuilderOptions? options,
  ) : super(
          options,
          <Block>[
            StringBlock(options, 'UPDATE'),
            UpdateTableBlock(options), // 1
            SetFieldBlock(options), // 2
            WhereBlock(options), // 3
            OrderByBlock(options), // 4
            LimitBlock(options) // 5
          ],
        );

  @override
  QueryBuilder table(String table, {String? alias}) {
    final UpdateTableBlock block = blocks[1] as UpdateTableBlock;
    block.setTable(table, alias);
    return this;
  }

  @override
  QueryBuilder set(String field, dynamic value) {
    final SetFieldBlock block = blocks[2] as SetFieldBlock;
    block.setFieldValue(field, value);
    return this;
  }

  @override
  QueryBuilder setAll(Map<String, dynamic> fieldsAndValues) {
    final SetFieldBlock block = blocks[2] as SetFieldBlock;

    fieldsAndValues.forEach((String field, dynamic value) {
      block.setFieldValue(field, value);
    });

    return this;
  }

  @override
  QueryBuilder where(String condition, [Object? param, String andOr = 'AND']) {
    final WhereBlock block = blocks[3] as WhereBlock;
    block.setWhere(condition, param, andOr);
    return this;
  }

  @override
  QueryBuilder whereExpr(Expression condition, [Object? param, String andOr = 'AND']) {
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
