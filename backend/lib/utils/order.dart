class Order {

  Order() :
    fields = <OrderField>[];

  final List<OrderField> fields;

  void add(String field, {OrderType type = OrderType.ASC, bool nullsLast = false}) {
    final OrderField orderField = OrderField(field, type, nullsLast);
    fields.add(orderField);
  }

  void addRaw(String rawField, {OrderType type = OrderType.ASC, bool nullsLast = false}) {
    final OrderField orderField = OrderRawField(rawField, type, nullsLast);
    fields.add(orderField);
  }

}

class OrderField {
  // ignore: avoid_positional_boolean_parameters
  const OrderField(this.field, this.type, this.nullsLast);

  final String field;
  final OrderType type;
  final bool nullsLast;
}

class OrderRawField extends OrderField {
  // ignore: avoid_positional_boolean_parameters
  OrderRawField(String field, OrderType type, bool nullsLast) : super(field, type, nullsLast);
}

enum OrderType {
  ASC,
  DESC,
}