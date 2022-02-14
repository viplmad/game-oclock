import '../query.dart' show Query;

abstract class GroupNode {}

class GroupStringNode extends GroupNode {
  GroupStringNode(this.field, this.table);

  final String field;
  final String? table;
}

class GroupSubqueryNode extends GroupNode {
  GroupSubqueryNode(this.query);

  final Query query;
}
