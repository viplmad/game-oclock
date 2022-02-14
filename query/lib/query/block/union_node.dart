import '../query.dart' show Query, UnionType;

abstract class UnionNode {
  UnionNode(this.type);

  final UnionType type;
}

class UnionTableNode extends UnionNode {
  UnionTableNode(this.table, UnionType type) : super(type);

  final String table;
}

class UnionSubqueryNode extends UnionNode {
  UnionSubqueryNode(this.query, UnionType type) : super(type);

  final Query query;
}
