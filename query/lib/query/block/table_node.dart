import '../query.dart' show Query;

abstract class TableNode {
  TableNode(this.alias);

  final String? alias;
}

class TableStringNode extends TableNode {
  TableStringNode(this.table, String? alias) : super(alias);

  final String table;
}

class TableSubqueryNode extends TableNode {
  TableSubqueryNode(this.query, String? alias) : super(alias);

  final Query query;
}
