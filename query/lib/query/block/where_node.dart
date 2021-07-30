import '../query.dart' show Query, OperatorType, DividerType, DatePart;
import 'field_node.dart';


abstract class WhereNode {
  WhereNode(this.operator, this.divider, this.combiner);

  final OperatorType operator;
  final DividerType divider;
  final CombinerType combiner;
}

enum CombinerType {
  AND,
  OR,
}

class WhereFieldNode extends WhereNode{
  WhereFieldNode(this.field, this.value, OperatorType operator, DividerType divider, CombinerType combiner) : super(operator, divider, combiner);

  final FieldStringNode field;
  final Object? value;
}

class WhereFieldDatePartNode extends WhereFieldNode {
  WhereFieldDatePartNode(FieldStringNode field, int value, this.datePart, OperatorType operator, DividerType divider, CombinerType combiner) : super(field, value, operator, divider, combiner);

  final DatePart datePart;
}

class WhereFieldsNode extends WhereNode{
  WhereFieldsNode(this.field, this.otherField, OperatorType operator, DividerType divider, CombinerType combiner) : super(operator, divider, combiner);

  final FieldStringNode field;
  final FieldStringNode otherField;
}

class WhereSubqueryNode extends WhereNode {
  WhereSubqueryNode(this.query, this.value, OperatorType operator, DividerType divider, CombinerType combiner) : super(operator, divider, combiner);

  final Query query;
  final Object? value;
}