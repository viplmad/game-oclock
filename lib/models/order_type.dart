class OrderType {
  /// Instantiate a new enum with the provided [value].
  const OrderType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  static const asc = OrderType._(r'Asc');
  static const desc = OrderType._(r'Desc');
}
