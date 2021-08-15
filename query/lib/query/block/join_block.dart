import '../query.dart' show Query, JoinType, FunctionType;
import 'block.dart' show Block;
import 'join_node.dart';
import 'field_node.dart';
import 'table_node.dart';


/// JOIN
class JoinBlock extends Block {
  JoinBlock() :
    this.joins = <JoinNode>[],
    super();

  final List<JoinNode> joins;

  /// Add a JOIN with the given table.
  /// @param table Name of the table to setJoin with.
  /// @param alias Optional alias for the table name.
  /// @param condition Optional condition (containing an SQL expression) for the JOIN.
  /// @param type Join Type.
  void setJoin(String table, String? alias, String field, String joinTable, String joinField, {JoinType type = JoinType.INNER, FunctionType function = FunctionType.NONE}) {
    final TableNode tableNode = TableStringNode(table, alias);
    final FieldStringNode fieldNode = FieldStringNode(field, null, alias?? table, function, null);
    final FieldStringNode joinFieldNode = FieldStringNode(joinField, null, joinTable, function, null);
    final JoinCondition condition = JoinCondition(fieldNode, joinFieldNode);
    final JoinNode node = JoinTableNode(tableNode, condition, type);
    joins.add(node);
  }

  void setJoinSubquery(Query query, String alias, String field, String joinTable, String joinField, {JoinType type = JoinType.INNER, FunctionType function = FunctionType.NONE}) {
    final FieldStringNode fieldNode = FieldStringNode(field, null, alias, function, null);
    final FieldStringNode joinFieldNode = FieldStringNode(joinField, null, joinTable, function, null);
    final JoinCondition condition = JoinCondition(fieldNode, joinFieldNode);
    final JoinNode node = JoinSubqueryNode(query, condition, type);
    joins.add(node);
  }
}
