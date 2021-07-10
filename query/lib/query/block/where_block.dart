import '../query.dart';
import '../operator_type.dart';
import '../divider_type.dart';
import '../date_part.dart';
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
  void setWhere(String field, Type? type, String? table, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _setWhere(field, type, table, value, operator, divider, CombinerType.AND);
  }

  void setOrWhere(String field, Type? type, String? table, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _setWhere(field, type, table, value, operator, divider, CombinerType.OR);
  }

  void setWhereDatePart(String field, String? table, int value, DatePart datePart, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _setWhereDatePart(field, table, value, datePart, operator, divider, CombinerType.AND);
  }

  void setOrWhereDatePart(String field, String? table, int value, DatePart datePart, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _setWhereDatePart(field, table, value, datePart, operator, divider, CombinerType.OR);
  }

  void setWhereFromSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _setWhereFromSubquery(query, value, operator, divider, CombinerType.AND);
  }

  void setOrWhereFromSubquery(Query query, Object? value, {OperatorType operator = OperatorType.EQ, DividerType divider = DividerType.NONE}) {
    _setWhereFromSubquery(query, value, operator, divider, CombinerType.OR);
  }

  void _setWhere(String field, Type? type, String? table, Object? value, OperatorType operator, DividerType divider, CombinerType combiner) {
    final FieldStringNode fieldNode = FieldStringNode(field, type, table, null);
    final WhereNode node = WhereFieldNode(fieldNode, value, operator, divider, combiner);
    wheres.add(node);
  }

  void _setWhereDatePart(String field, String? table, int value, DatePart datePart, OperatorType operator, DividerType divider, CombinerType combiner) {
    final FieldStringNode fieldNode = FieldStringNode(field, int, table, null);
    final WhereNode node = WhereFieldDatePartNode(fieldNode, value, datePart, operator, divider, combiner);
    wheres.add(node);
  }

  void _setWhereFromSubquery(Query query, Object? value, OperatorType operator, DividerType divider, CombinerType combiner) {
    final WhereNode node = WhereSubqueryNode(query, value, operator, divider, combiner);
    wheres.add(node);
  }
}
