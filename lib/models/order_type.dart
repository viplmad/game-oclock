class OrderType {
  /// Instantiate a new enum with the provided [value].
  const OrderType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  static const asc = OrderType._(r'Asc');
  static const desc = OrderType._(r'Desc');

  String toJson() => value;

  static OrderType? fromJson(final dynamic value) =>
      OrderTypeTypeTransformer().decode(value);
}

/// Transformation class that can [encode] an instance of [OrderType] to String,
/// and [decode] dynamic data back to [OrderType].
class OrderTypeTypeTransformer {
  factory OrderTypeTypeTransformer() =>
      _instance ??= const OrderTypeTypeTransformer._();

  const OrderTypeTypeTransformer._();

  String encode(final OrderType data) => data.value;

  /// Decodes a [dynamic value][data] to a OrderType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OrderType? decode(final dynamic data, {final bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Asc':
          return OrderType.asc;
        case r'Desc':
          return OrderType.desc;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OrderTypeTypeTransformer] instance.
  static OrderTypeTypeTransformer? _instance;
}
