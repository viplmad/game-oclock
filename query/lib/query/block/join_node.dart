import '../query.dart';
import '../join_type.dart';
import '../operator_type.dart';
import 'field_node.dart';
import 'table_node.dart';


abstract class JoinNode {
  JoinNode(this.condition, this.type);

  final JoinCondition condition;
  final JoinType type;
}

class JoinTableNode extends JoinNode {
  JoinTableNode(this.table, JoinCondition condition, JoinType type) : super(condition, type);

  final TableNode table;
}

class JoinSubqueryNode extends JoinNode {
  JoinSubqueryNode(this.query, JoinCondition condition, JoinType type) : super(condition, type);

  final Query query;
}

class JoinCondition {
  JoinCondition(this.field, this.joinField) :
    this.operator = OperatorType.EQ;

  final FieldStringNode field;
  final FieldStringNode joinField;
  final OperatorType operator;
}