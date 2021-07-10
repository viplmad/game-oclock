import '../query.dart';


abstract class FieldNode {
  FieldNode(this.alias);

  final String? alias;
}

class FieldStringNode extends FieldNode {
  FieldStringNode(this.name, this.type, this.table, String? alias) : super(alias);

  final String name;
  final Type? type;
  final String? table;
}

class FieldSubqueryNode extends FieldNode {
  FieldSubqueryNode(this.query, String? alias) : super(alias);

  final Query query;
}