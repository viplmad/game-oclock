export 'date_part.dart';
export 'divider_type.dart';
export 'function_type.dart';
export 'join_type.dart';
export 'operator_type.dart';
export 'sort_order.dart';
export 'union_type.dart';

import 'package:meta/meta.dart';

import 'block/block.dart';
import 'date_part.dart';
import 'divider_type.dart';
import 'function_type.dart';
import 'join_type.dart';
import 'operator_type.dart';
import 'sort_order.dart';
import 'union_type.dart';
import 'exception.dart';


abstract class Query {
  Query(List<Block>? blocks) {
    this.blocks = blocks ?? <Block>[];
  }

  late final List<Block> blocks;

  @protected
  DistinctBlock distinctBlock() {
    throw UnsupportedOperationException('`distinct` not implemented');
  }

  @protected
  FromTableBlock fromTableBlock() {
    throw UnsupportedOperationException('`from` not implemented');
  }

  @protected
  GetFieldBlock getFieldBlock() {
    throw UnsupportedOperationException('`field` not implemented');
  }

  @protected
  ReturningFieldBlock returningFieldBlock() {
    throw UnsupportedOperationException('`returningField` not implemented');
  }

  @protected
  GroupBlock groupBlock() {
    throw UnsupportedOperationException('`group` not implemented');
  }

  @protected
  JoinBlock joinBlock() {
    throw UnsupportedOperationException('`join` not implemented');
  }

  @protected
  WhereBlock whereBlock() {
    throw UnsupportedOperationException('`where` not implemented');
  }

  @protected
  LimitBlock limitBlock() {
    throw UnsupportedOperationException('`limit` not implemented');
  }

  @protected
  OrderBlock orderBlock() {
    throw UnsupportedOperationException('`limit` not implemented');
  }

  @protected
  OffsetBlock offsetBlock() {
    throw UnsupportedOperationException('`offset` not implemented');
  }

  @protected
  UnionBlock unionBlock() {
    throw UnsupportedOperationException('union not implemented');
  }

  @protected
  UpdateTableBlock updateTableBlock() {
    throw UnsupportedOperationException('`table` not implemented');
  }

  @protected
  IntoTableBlock intoTableBlock() {
    throw UnsupportedOperationException('`into` not implemented');
  }

  @protected
  InsertFieldsFromQueryBlock insertFieldsFromQueryBlock() {
    throw UnsupportedOperationException('`fromQuery` not implemented');
  }

  //
  // DISTINCT
  //
  Query distinct() {
    distinctBlock().setDistinct();
    return this;
  }

  //
  // FROM
  //
  Query from(String table, {String? alias}) {
    fromTableBlock().setFrom(table, alias);
    return this;
  }

  Query fromSubquery(Query query, {String? alias}) {
    fromTableBlock().setFromSubquery(query, alias);
    return this;
  }

  //
  // GET FIELDS
  //
  Query field(String field, {Type? type, String? table, String? alias, FunctionType function = FunctionType.NONE}) {
    getFieldBlock().setField(field, type, table, alias, function: function);
    return this;
  }

  Query fieldSubquery(Query query, {String? alias, FunctionType function = FunctionType.NONE}) {
    getFieldBlock().setFieldFromSubquery(query, alias, function: function);
    return this;
  }

  Query fields(Iterable<String> fields, {String? table}) {
    getFieldBlock().setFields(fields, table);
    return this;
  }

  //
  // RETURNING FIELDS
  //
  Query returningField(String field) {
    returningFieldBlock().setRetuningField(field);
    return this;
  }

  //
  // GROUP
  //
  Query group(String field, {String? table}) {
    groupBlock().setGroup(field, table);
    return this;
  }

  Query groupSubquery(Query query) {
    groupBlock().setGroupFromSubquery(query);
    return this;
  }

  Query groups(Iterable<String> fields, {String? table}) {
    groupBlock().setGroups(fields, table);
    return this;
  }

  //
  // JOIN
  //
  Query join(String table, String? alias, String field, String joinTable, String joinField, {JoinType type = JoinType.INNER, FunctionType function = FunctionType.NONE}) {
    joinBlock().setJoin(table, alias, field, joinTable, joinField, type: type, function: function);
    return this;
  }

  Query joinSubquery(Query query, String alias, String field, String joinTable, String joinField, {JoinType type = JoinType.INNER, FunctionType function = FunctionType.NONE}) {
    joinBlock().setJoinSubquery(query, alias, field, joinTable, joinField, type: type, function: function);
    return this;
  }

  //
  // WHERE
  //
  Query where(String field, Object? value, {Type? type, String? table, OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    whereBlock().setWhere(field, type, table, value, operator: operator, function: function, divider: divider);
    return this;
  }

  Query orWhere(String field, Object? value, {Type? type, String? table, OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    whereBlock().setOrWhere(field, type, table, value, operator: operator, function: function,  divider: divider);
    return this;
  }

  Query whereDatePart(String field, int value, DatePart datePart, {String? table, OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    whereBlock().setWhereDatePart(field, table, value, datePart, operator: operator, function: function,  divider: divider);
    return this;
  }

  Query orWhereDatePart(String field, int value, DatePart datePart, {String? table, OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    whereBlock().setOrWhereDatePart(field, table, value, datePart, operator: operator, function: function,  divider: divider);
    return this;
  }

  Query whereFields(String table, String field, String otherTable, String otherField, {OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, FunctionType otherFunction = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    whereBlock().setWhereFields(table, field, otherTable, otherField, operator: operator, function: function, otherFunction: otherFunction, divider: divider);
    return this;
  }

  Query orWhereFields(String table, String field, String otherTable, String otherField, {Type? otherType, OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, FunctionType otherFunction = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    whereBlock().setOrWhereFields(table, field, otherTable, otherField, operator: operator, function: function, otherFunction: otherFunction, divider: divider);
    return this;
  }

  Query whereSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    whereBlock().setWhereFromSubquery(query, value, operator: operator, divider: divider);
    return this;
  }

  Query orWhereSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    whereBlock().setOrWhereFromSubquery(query, value, operator: operator, divider: divider);
    return this;
  }

  //
  // LIMIT
  //
  Query limit(int? value) {
    if(value != null) {
      limitBlock().setLimit(value);
    }
    return this;
  }

  //
  // ORDER BY
  //
  Query order(String field, String? table, {SortOrder direction = SortOrder.ASC, FunctionType function = FunctionType.NONE, bool nullsLast = false}) {
    orderBlock().setOrder(field, table, direction: direction, function: function, nullsLast: nullsLast);
    return this;
  }

  Query orderSubquery(Query query, {SortOrder direction = SortOrder.ASC, bool nullsLast = false}) {
    orderBlock().setOrderFromSubquery(query, direction: direction, nullsLast: nullsLast);
    return this;
  }

  //
  // OFFSET
  //
  Query offset(int value) {
    offsetBlock().setOffset(value);
    return this;
  }

  //
  // UNION
  //
  Query union(String table, {UnionType unionType = UnionType.UNION}) {
    unionBlock().setUnion(table, unionType: unionType);
    return this;
  }

  Query unionSubquery(Query query, {UnionType unionType = UnionType.UNION}) {
    unionBlock().setUnionSubquery(query, unionType: unionType);
    return this;
  }

  //
  // TABLE
  //
  Query table(String table, {String? alias}) {
    updateTableBlock().setTable(table, alias);
    return this;
  }

  Query tableSubquery(Query query, {String? alias}) {
    updateTableBlock().setTableFromSubquery(query, alias);
    return this;
  }

  //
  // SET
  //
  Query set(String field, Object? value) {
    throw UnsupportedOperationException('`set` not implemented');
  }

  Query sets(Map<String, Object?> fieldsAndValues) {
    throw UnsupportedOperationException('`sets` not implemented');
  }

  //
  // INTO
  //
  Query into(String table) {
    intoTableBlock().setInto(table);
    return this;
  }

  //
  // `FROM QUERY`
  //
  Query fromQuery(Iterable<String> fields, Query query) {
    insertFieldsFromQueryBlock().setFromQuery(fields, query);
    return this;
  }
}
