import 'package:query/query/block/returning_field_block.dart';

import 'block/block.dart';

import 'query.dart';
import 'sort_order.dart';
import 'union_type.dart';
import 'join_type.dart';
import 'operator_type.dart';
import 'divider_type.dart';
import 'date_part.dart';


/// SELECT query builder.
class Select extends Query {
  Select() : super(
    <Block>[
      SelectBlock(),
      DistinctBlock(), // 1
      GetFieldBlock(), // 2
      FromTableBlock(), // 3
      JoinBlock(), // 4
      WhereBlock(), // 5
      GroupBlock(), // 6
      OrderBlock(), // 7
      LimitBlock(), // 8
      OffsetBlock(), // 9
      UnionBlock(), // 10
    ],
  );

  DistinctBlock _distinctBlock() {
    return blocks[1] as DistinctBlock;
  }

  GetFieldBlock _getFieldBlock() {
    return blocks[2] as GetFieldBlock;
  }

  FromTableBlock _fromTableBlock() {
    return blocks[3] as FromTableBlock;
  }

  JoinBlock _joinBlock() {
    return blocks[4] as JoinBlock;
  }

  WhereBlock _whereBlock() {
    return blocks[5] as WhereBlock;
  }

  GroupBlock _groupBlock() {
    return blocks[6] as GroupBlock;
  }

  OrderBlock _orderBlock() {
    return blocks[7] as OrderBlock;
  }

  LimitBlock _limitBlock() {
    return blocks[8] as LimitBlock;
  }

  OffsetBlock _offsetBlock() {
    return blocks[9] as OffsetBlock;
  }

  UnionBlock _unionBlock() {
    return blocks[10] as UnionBlock;
  }

  //
  // DISTINCT
  //
  @override
  Query distinct() {
    _distinctBlock().setDistinct();
    return this;
  }

  //
  // FROM
  //
  @override
  Query from(String table, {String? alias}) {
    _fromTableBlock().setFrom(table, alias);
    return this;
  }

  @override
  Query fromSubquery(Query query, {String? alias}) {
    _fromTableBlock().setFromSubquery(query, alias);
    return this;
  }

  //
  // GET
  //
  @override
  Query field(String field, {Type? type, String? table, String? alias}) {
    _getFieldBlock().setField(field, type, table, alias);
    return this;
  }

  @override
  Query fieldSubquery(Query query, {String? alias}) {
    _getFieldBlock().setFieldFromSubquery(query, alias);
    return this;
  }

  @override
  Query fields(Iterable<String> fields, {String? table}) {
    _getFieldBlock().setFields(fields, table);
    return this;
  }

  //
  // GROUP
  //
  @override
  Query group(String field, {String? table}) {
    _groupBlock().setGroup(field, table);
    return this;
  }

  @override
  Query groupSubquery(Query query) {
    _groupBlock().setGroupFromSubquery(query);
    return this;
  }

  @override
  Query groups(Iterable<String> fields, {String? table}) {
    _groupBlock().setGroups(fields, table);
    return this;
  }

  //
  // JOIN
  //
  @override
  Query join(String table, String? alias, String field, String joinTable, String joinField, {JoinType type = JoinType.INNER}) {
    _joinBlock().setJoin(table, alias, field, joinTable, joinField, type: type);
    return this;
  }

  @override
  Query joinSubquery(Query query, String alias, String field, String joinTable, String joinField, {JoinType type = JoinType.INNER}) {
    _joinBlock().setJoinSubquery(query, alias, field, joinTable, joinField, type: type);
    return this;
  }

  //
  // WHERE
  //
  @override
  Query where(String field, Object? value, {Type? type, String? table, OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _whereBlock().setWhere(field, type, table, value, operator: operator, divider: divider);
    return this;
  }

  @override
  Query orWhere(String field, Object? value, {Type? type, String? table, OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _whereBlock().setOrWhere(field, type, table, value, operator: operator, divider: divider);
    return this;
  }

  @override
  Query whereDatePart(String field, int value, DatePart datePart, {String? table, OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _whereBlock().setWhereDatePart(field, table, value, datePart, operator: operator, divider: divider);
    return this;
  }

  @override
  Query orWhereDatePart(String field, int value, DatePart datePart, {String? table, OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _whereBlock().setOrWhereDatePart(field, table, value, datePart, operator: operator, divider: divider);
    return this;
  }

  @override
  Query whereSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _whereBlock().setWhereFromSubquery(query, value, operator: operator, divider: divider);
    return this;
  }

  @override
  Query orWhereSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _whereBlock().setOrWhereFromSubquery(query, value, operator: operator, divider: divider);
    return this;
  }

  //
  // LIMIT
  //
  @override
  Query limit(int? value) {
    if(value != null) {
      _limitBlock().setLimit(value);
    }
    return this;
  }

  //
  // ORDER BY
  //
  @override
  Query order(String field, String? table, {SortOrder direction = SortOrder.ASC, bool nullsLast = false}) {
    _orderBlock().setOrder(field, table, direction: direction, nullsLast: nullsLast);
    return this;
  }

  @override
  Query orderSubquery(Query query, {SortOrder direction = SortOrder.ASC, bool nullsLast = false}) {
    _orderBlock().setOrderFromSubquery(query, direction: direction, nullsLast: nullsLast);
    return this;
  }

  //
  // OFFSET
  //
  @override
  Query offset(int value) {
    _offsetBlock().setOffset(value);
    return this;
  }

  //
  // UNION
  //
  @override
  Query union(String table, {UnionType unionType = UnionType.UNION}) {
    _unionBlock().setUnion(table, unionType: unionType);
    return this;
  }

  @override
  Query unionSubquery(Query query, {UnionType unionType = UnionType.UNION}) {
    _unionBlock().setUnionSubquery(query, unionType: unionType);
    return this;
  }
}
