import '../query.dart';
import '../sort_order.dart';
import 'block.dart';
import 'order_node.dart';
import 'field_node.dart';


/// ORDER BY
class OrderBlock extends Block {
  OrderBlock() :
    this.orders = <OrderNode>[],
    super();

  final List<OrderNode> orders;

  /// Add an ORDER BY transformation for the given setField in the given order.
  /// @param field Field
  /// @param dir Order
  void setOrder(String field, String? table, {SortOrder direction = SortOrder.ASC, bool nullsLast = false}) {
    final FieldNode fieldNode = FieldStringNode(field, null, table, null);
    final OrderNode node = OrderFieldNode(fieldNode, direction, nullsLast);
    orders.add(node);
  }

  void setOrderFromSubquery(Query query, {SortOrder direction = SortOrder.ASC, bool nullsLast = false}) {
    final OrderNode node = OrderSubqueryNode(query, direction, nullsLast);
    orders.add(node);
  }
}
