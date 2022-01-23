import '../query.dart' show Query, OperatorType, DividerType, DatePart, FunctionType;
import 'block.dart';


/// WHERE
class WhereBlock extends Block {
  WhereBlock() :
    wheres = <WhereNode>[],
    super();

  final List<WhereNode> wheres;

  /// Add a WHERE condition.
  void setWhere(String field, Type? type, String? table, Object? value, {OperatorType operator = OperatorType.eq, FunctionType function = FunctionType.none, DividerType divider = DividerType.none}) {
    _setWhere(field, type, table, value, operator, function, divider, CombinerType.and);
  }

  void setOrWhere(String field, Type? type, String? table, Object? value, {OperatorType operator = OperatorType.eq, FunctionType function = FunctionType.none, DividerType divider = DividerType.none}) {
    _setWhere(field, type, table, value, operator, function, divider, CombinerType.or);
  }

  void setWhereDatePart(String field, String? table, int value, DatePart datePart, {OperatorType operator = OperatorType.eq, FunctionType function = FunctionType.none, DividerType divider = DividerType.none}) {
    _setWhereDatePart(field, table, value, datePart, operator, function, divider, CombinerType.and);
  }

  void setOrWhereDatePart(String field, String? table, int value, DatePart datePart, {OperatorType operator = OperatorType.eq, FunctionType function = FunctionType.none, DividerType divider = DividerType.none}) {
    _setWhereDatePart(field, table, value, datePart, operator, function, divider, CombinerType.or);
  }

  void setWhereFields(String table, String field, String otherTable, String otherField, {OperatorType operator = OperatorType.eq, FunctionType function = FunctionType.none, FunctionType otherFunction = FunctionType.none, DividerType divider = DividerType.none}) {
    _setWhereFields(table, field, otherTable, otherField, operator, function, otherFunction, divider, CombinerType.and);
  }

  void setOrWhereFields(String table, String field, String otherTable, String otherField, {OperatorType operator = OperatorType.eq, FunctionType function = FunctionType.none, FunctionType otherFunction = FunctionType.none, DividerType divider = DividerType.none}) {
    _setWhereFields(table, field, otherTable, otherField, operator, function, otherFunction, divider, CombinerType.or);
  }

  void setWhereFromSubquery(Query query, Object? value, {OperatorType operator = OperatorType.eq, DividerType divider = DividerType.none}) {
    _setWhereFromSubquery(query, value, operator, divider, CombinerType.and);
  }

  void setOrWhereFromSubquery(Query query, Object? value, {OperatorType operator = OperatorType.eq, DividerType divider = DividerType.none}) {
    _setWhereFromSubquery(query, value, operator, divider, CombinerType.or);
  }

  void _setWhere(String field, Type? type, String? table, Object? value, OperatorType operator, FunctionType function, DividerType divider, CombinerType combiner) {
    final FieldStringNode fieldNode = FieldStringNode(field, type, table, function, null);
    final WhereNode node = WhereFieldValueNode(fieldNode, value, operator, divider, combiner);
    wheres.add(node);
  }

  void _setWhereDatePart(String field, String? table, int value, DatePart datePart, OperatorType operator, FunctionType function, DividerType divider, CombinerType combiner) {
    final FieldStringNode fieldNode = FieldStringNode(field, int, table, function, null);
    final WhereNode node = WhereFieldDatePartNode(fieldNode, value, datePart, operator, divider, combiner);
    wheres.add(node);
  }

  void _setWhereFields(String table, String field, String otherTable, String otherField, OperatorType operator, FunctionType function, FunctionType otherFunction, DividerType divider, CombinerType combiner) {
    final FieldStringNode fieldNode = FieldStringNode(field, null, table, function, null);
    final FieldStringNode otherFieldNode = FieldStringNode(otherField, null, otherTable, otherFunction, null);
    final WhereNode node = WhereFieldsNode(fieldNode, otherFieldNode, operator, divider, combiner);
    wheres.add(node);
  }

  void _setWhereFromSubquery(Query query, Object? value, OperatorType operator, DividerType divider, CombinerType combiner) {
    final WhereNode node = WhereSubqueryNode(query, value, operator, divider, combiner);
    wheres.add(node);
  }
}
