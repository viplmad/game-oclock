import '../query.dart' show Query, OperatorType, DividerType, DatePart, FunctionType;
import 'block.dart';
import 'where_node.dart';
import 'field_node.dart';


/// WHERE
class WhereBlock extends Block {
  WhereBlock() :
    this.wheres = <WhereNode>[],
    super();

  final List<WhereNode> wheres;

  /// Add a WHERE condition.
  void setWhere(String field, Type? type, String? table, Object? value, {OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    _setWhere(field, type, table, value, operator, function, divider, CombinerType.AND);
  }

  void setOrWhere(String field, Type? type, String? table, Object? value, {OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    _setWhere(field, type, table, value, operator, function, divider, CombinerType.OR);
  }

  void setWhereDatePart(String field, String? table, int value, DatePart datePart, {OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    _setWhereDatePart(field, table, value, datePart, operator, function, divider, CombinerType.AND);
  }

  void setOrWhereDatePart(String field, String? table, int value, DatePart datePart, {OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    _setWhereDatePart(field, table, value, datePart, operator, function, divider, CombinerType.OR);
  }

  void setWhereFields(String table, String field, String otherTable, String otherField, {OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, FunctionType otherFunction = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    _setWhereFields(table, field, otherTable, otherField, operator, function, otherFunction, divider, CombinerType.AND);
  }

  void setOrWhereFields(String table, String field, String otherTable, String otherField, {OperatorType operator = OperatorType.EQ, FunctionType function = FunctionType.NONE, FunctionType otherFunction = FunctionType.NONE, DividerType divider = DividerType.NONE}) {
    _setWhereFields(table, field, otherTable, otherField, operator, function, otherFunction, divider, CombinerType.OR);
  }

  void setWhereFromSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _setWhereFromSubquery(query, value, operator, divider, CombinerType.AND);
  }

  void setOrWhereFromSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _setWhereFromSubquery(query, value, operator, divider, CombinerType.OR);
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
