import 'package:query/query/block/returning_field_block.dart';

import 'block/block.dart';

import 'query.dart';
import 'join_type.dart';
import 'operator_type.dart';
import 'divider_type.dart';
import 'date_part.dart';


/// DELETE query builder.
class Delete extends Query {
  Delete() : super(
    <Block>[
      DeleteBlock(),
      FromTableBlock(), // 1
      JoinBlock(), // 2
      WhereBlock(), // 3
      ReturningFieldBlock(), // 4
    ],
  );

  FromTableBlock _fromTableBlock() {
    return blocks[1] as FromTableBlock;
  }

  JoinBlock _joinBlock() {
    return blocks[2] as JoinBlock;
  }

  WhereBlock _whereBlock() {
    return blocks[3] as WhereBlock;
  }

  ReturningFieldBlock _returningFieldBlock() {
    return blocks[4] as ReturningFieldBlock;
  }

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

  @override
  Query returningField(String field) {
    _returningFieldBlock().setRetuningField(field);
    return this;
  }
}
