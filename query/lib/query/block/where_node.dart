import 'package:query/query/block/block.dart';

import '../query.dart' show Query, OperatorType, DividerType, DatePart;
import 'field_node.dart';


abstract class WhereNode {
  WhereNode(this.operator, this.divider, this.combiner);

  final OperatorType operator;
  final DividerType divider;
  final CombinerType combiner;
}

abstract class WhereValueNode extends WhereNode {
  WhereValueNode(this.value, OperatorType operator, DividerType divider, CombinerType combiner) : super(operator, divider, combiner);

  final Object? value;
}

enum CombinerType {
  and,
  or,
}

class WhereFieldValueNode extends WhereValueNode {
  WhereFieldValueNode(this.field, Object? value, OperatorType operator, DividerType divider, CombinerType combiner) : super(value, operator, divider, combiner);

  final FieldStringNode field;
}

class WhereFieldDatePartNode extends WhereFieldValueNode {
  WhereFieldDatePartNode(FieldStringNode field, int value, this.datePart, OperatorType operator, DividerType divider, CombinerType combiner) : super(field, value, operator, divider, combiner);

  final DatePart datePart;
}

class WhereFieldsNode extends WhereNode {
  WhereFieldsNode(this.field, this.otherField, OperatorType operator, DividerType divider, CombinerType combiner) : super(operator, divider, combiner);

  final FieldStringNode field;
  final FieldStringNode otherField;
}

class WhereSubqueryNode extends WhereValueNode {
  WhereSubqueryNode(this.query, Object? value, OperatorType operator, DividerType divider, CombinerType combiner) : super(value, operator, divider, combiner);

  final Query query;
}