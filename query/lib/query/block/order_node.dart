import '../query.dart' show Query, SortOrder;
import 'field_node.dart';


abstract class OrderNode {
  // ignore: avoid_positional_boolean_parameters
  OrderNode(this.direction, this.nullsLast);

  final SortOrder direction;
  final bool nullsLast;
}

class OrderFieldNode extends OrderNode {
  // ignore: avoid_positional_boolean_parameters
  OrderFieldNode(this.field, SortOrder direction, bool nullsLast) : super(direction, nullsLast);

  final FieldNode field;
}

class OrderSubqueryNode extends OrderNode {
  // ignore: avoid_positional_boolean_parameters
  OrderSubqueryNode(this.query, SortOrder direction, bool nullsLast) : super(direction, nullsLast);

  final Query query;
}