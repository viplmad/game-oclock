import '../query.dart' show Query, SortOrder, FunctionType;
import 'block.dart' show Block;
import 'order_node.dart';
import 'field_node.dart';


/// ORDER BY
class OrderBlock extends Block {
  OrderBlock() :
    orders = <OrderNode>[],
    super();

  final List<OrderNode> orders;

  /// Add an ORDER BY transformation for the given setField in the given order.
  /// @param field Field
  /// @param dir Order
  void setOrder(String field, String? table, {SortOrder direction = SortOrder.asc, bool nullsLast = false, FunctionType function = FunctionType.none}) {
    final FieldNode fieldNode = FieldStringNode(field, null, table, function, null);
    final OrderNode node = OrderFieldNode(fieldNode, direction, nullsLast);
    orders.add(node);
  }

  void setOrderFromSubquery(Query query, {SortOrder direction = SortOrder.asc, bool nullsLast = false}) {
    final OrderNode node = OrderSubqueryNode(query, direction, nullsLast);
    orders.add(node);
  }
}
