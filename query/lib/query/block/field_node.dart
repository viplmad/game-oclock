import '../query.dart' show Query, FunctionType;

abstract class FieldNode {
  FieldNode(this.function, this.alias);

  final FunctionType function;
  final String? alias;
}

class FieldStringNode extends FieldNode {
  FieldStringNode(
    this.name,
    this.type,
    this.table,
    FunctionType function,
    String? alias,
  ) : super(function, alias);

  final String name;
  final Type? type;
  final String? table;
}

class FieldSubqueryNode extends FieldNode {
  FieldSubqueryNode(this.query, FunctionType function, String? alias)
      : super(function, alias);

  final Query query;
}
