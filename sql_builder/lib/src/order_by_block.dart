import 'block.dart';
import 'query_builder.dart';
import 'query_builder_options.dart';
import 'sort_order.dart';
import 'validator.dart';

class OrderNode {
  // ignore: avoid_positional_boolean_parameters
  OrderNode(this.field, this.dir, this.nullsLast);
  final String field;
  final SortOrder dir;
  final bool nullsLast;
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
  void setOrder(String field, SortOrder dir, {bool nullsLast = false}) {
    final String fld = Validator.sanitizeField(field, options);
    orders.add(OrderNode(fld, dir, nullsLast));
  }

  void setOrderRaw(String fieldRaw, SortOrder dir, {bool nullsLast = false}) {
    orders.add(OrderNode(fieldRaw, dir, nullsLast));
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
      sb.write(o.nullsLast ? ' NULLS LAST' : '');
    }

    return '$text $sb';
  }
}
