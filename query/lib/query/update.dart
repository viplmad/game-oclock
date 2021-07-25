import 'block/block.dart';

import 'query.dart';
import 'operator_type.dart';
import 'divider_type.dart';
import 'date_part.dart';


/// UPDATE query builder.
class Update extends Query {
  Update() : super(
    <Block>[
      UpdateBlock(),
      UpdateTableBlock(), // 1
      SetFieldBlock(), // 2
      WhereBlock(), // 3
      ReturningFieldBlock(), // 4
    ],
  );

  UpdateTableBlock _updateTableBlock() {
    return blocks[1] as UpdateTableBlock;
  }

  SetFieldBlock _setFieldBlock() {
    return blocks[2] as SetFieldBlock;
  }

  WhereBlock _whereBlock() {
    return blocks[3] as WhereBlock;
  }

  ReturningFieldBlock _returningFieldBlock() {
    return blocks[4] as ReturningFieldBlock;
  }

  @override
  Query table(String table, {String? alias}) {
    _updateTableBlock().setTable(table, alias);
    return this;
  }

  @override
  Query tableSubquery(Query query, {String? alias}) {
    _updateTableBlock().setTableFromSubquery(query, alias);
    return this;
  }

  @override
  Query set(String field, dynamic value) {
    _setFieldBlock().setFieldValue(field, value);
    return this;
  }

  @override
  Query sets(Map<String, Object?> fieldsAndValues) {
    fieldsAndValues.forEach((String field, Object? value) {
      _setFieldBlock().setFieldValue(field, value);
    });
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
  Query returningField(String field) {
    _returningFieldBlock().setRetuningField(field);
    return this;
  }
}
