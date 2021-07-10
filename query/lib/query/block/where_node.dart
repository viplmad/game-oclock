import '../query.dart';
import '../operator_type.dart';
import '../divider_type.dart';
import '../date_part.dart';
import 'field_node.dart';


abstract class WhereNode {
  WhereNode(this.value, this.operator, this.divider, this.combiner);

  final Object? value;
  final OperatorType operator;
  final DividerType divider;
  final CombinerType combiner;
}

enum CombinerType {
  AND,
  OR,
}

class WhereFieldNode extends WhereNode{
  WhereFieldNode(this.field, Object? value, OperatorType operator, DividerType divider, CombinerType combiner) : super(value, operator, divider, combiner);

  final FieldStringNode field;
}

class WhereFieldDatePartNode extends WhereFieldNode {
  WhereFieldDatePartNode(FieldStringNode field, int value, this.datePart, OperatorType operator, DividerType divider, CombinerType combiner) : super(field, value, operator, divider, combiner);

  final DatePart datePart;
}

class WhereSubqueryNode extends WhereNode {
  WhereSubqueryNode(this.query, Object? value, OperatorType operator, DividerType divider, CombinerType combiner) : super(value, operator, divider, combiner);

  final Query query;
}