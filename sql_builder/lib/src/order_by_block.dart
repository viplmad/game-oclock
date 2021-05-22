import 'block.dart';
import 'query_builder.dart';
import 'query_builder_options.dart';
import 'sort_order.dart';
import 'validator.dart';

class OrderNode {
  OrderNode(this.field, this.dir);
  final String field;
  final SortOrder dir;
}

/// ORDER BY
class OrderByBlock extends Block {
  OrderByBlock(QueryBuilderOptions? options) :
        this.orders = <OrderNode>[],
        super(options);
  final String text = 'ORDER BY';
  final List<OrderNode> orders;

  /// Add an ORDER BY transformation for the given setField in the given order.
  /// @param field Field
  /// @param dir Order
  void setOrder(String field, SortOrder dir) {
    final String fld = Validator.sanitizeField(field, options);
    orders.add(OrderNode(fld, dir));
  }

  @override
  String buildStr(QueryBuilder queryBuilder) {
    if (orders.isEmpty) {
      return '';
    }

    final StringBuffer sb = StringBuffer();
    for (final OrderNode o in orders) {
      if (sb.length > 0) {
        sb.write(', ');
      }

      sb.write(o.field);
      sb.write(' ');
      sb.write(o.dir == SortOrder.ASC ? 'ASC' : 'DESC');
    }

    return '$text $sb';
  }
}
