import '../query.dart' show Query, UnionType;
import 'block.dart' show Block;
import 'union_node.dart';


/// UNION
class UnionBlock extends Block {
  UnionBlock() :
    this.unions = <UnionNode>[],
    super();

  final List<UnionNode> unions;

  /// Add a UNION with the given table/query.
  /// @param table Name of the table or query to union with.
  /// @param unionType Type of the union.
  void setUnion(String table, {UnionType unionType = UnionType.UNION}) {
    final UnionNode node = UnionTableNode(table, unionType);
    unions.add(node);
  }

  void setUnionSubquery(Query query, {UnionType unionType = UnionType.UNION}) {
    final UnionNode node = UnionSubqueryNode(query, unionType);
    unions.add(node);
  }
}
