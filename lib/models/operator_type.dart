import 'package:game_oclock/utils/localisation_extension.dart';

import 'nav_destination.dart';

List<DropdownField> operatorsMenuEntries = List.unmodifiable(<DropdownField>[
  DropdownField(
    value: 'Eq',
    labelBuilder: (final context) => context.localize().equalLabel,
  ),
  DropdownField(
    value: 'NotEq',
    labelBuilder: (final context) => context.localize().notEqualLabel,
  ),
  DropdownField(
    value: 'Gt',
    labelBuilder: (final context) => context.localize().greaterThanLabel,
  ),
  DropdownField(
    value: 'Gte',
    labelBuilder: (final context) => context.localize().greaterThanEqualLabel,
  ),
  DropdownField(
    value: 'Lt',
    labelBuilder: (final context) => context.localize().lessThanLabel,
  ),
  DropdownField(
    value: 'Lte',
    labelBuilder: (final context) => context.localize().lessThanEqualLabel,
  ),
  DropdownField(
    value: 'StartsWith',
    labelBuilder: (final context) => context.localize().startsWithLabel,
  ),
  DropdownField(
    value: 'NotStartsWith',
    labelBuilder: (final context) => context.localize().notStartsWithLabel,
  ),
  DropdownField(
    value: 'EndsWith',
    labelBuilder: (final context) => context.localize().endsWithLabel,
  ),
  DropdownField(
    value: 'NotEndsWith',
    labelBuilder: (final context) => context.localize().notEndsWithLabel,
  ),
  DropdownField(
    value: 'Contains',
    labelBuilder: (final context) => context.localize().containsLabel,
  ),
  DropdownField(
    value: 'NotContains',
    labelBuilder: (final context) => context.localize().notContainsLabel,
  ),
]);

class OperatorType {
  /// Instantiate a new enum with the provided [value].
  const OperatorType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  static const eq = OperatorType._(r'Eq');
  static const notEq = OperatorType._(r'NotEq');
  static const gt = OperatorType._(r'Gt');
  static const gte = OperatorType._(r'Gte');
  static const lt = OperatorType._(r'Lt');
  static const lte = OperatorType._(r'Lte');
  static const in_ = OperatorType._(r'In');
  static const notIn = OperatorType._(r'NotIn');
  static const startsWith = OperatorType._(r'StartsWith');
  static const notStartsWith = OperatorType._(r'NotStartsWith');
  static const endsWith = OperatorType._(r'EndsWith');
  static const notEndsWith = OperatorType._(r'NotEndsWith');
  static const contains = OperatorType._(r'Contains');
  static const notContains = OperatorType._(r'NotContains');

  static OperatorType? fromJson(dynamic value) =>
      OperatorTypeTypeTransformer().decode(value);
}

/// Transformation class that can [encode] an instance of [OperatorType] to String,
/// and [decode] dynamic data back to [OperatorType].
class OperatorTypeTypeTransformer {
  factory OperatorTypeTypeTransformer() =>
      _instance ??= const OperatorTypeTypeTransformer._();

  const OperatorTypeTypeTransformer._();

  String encode(OperatorType data) => data.value;

  /// Decodes a [dynamic value][data] to a OperatorType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OperatorType? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Eq':
          return OperatorType.eq;
        case r'NotEq':
          return OperatorType.notEq;
        case r'Gt':
          return OperatorType.gt;
        case r'Gte':
          return OperatorType.gte;
        case r'Lt':
          return OperatorType.lt;
        case r'Lte':
          return OperatorType.lte;
        case r'In':
          return OperatorType.in_;
        case r'NotIn':
          return OperatorType.notIn;
        case r'StartsWith':
          return OperatorType.startsWith;
        case r'NotStartsWith':
          return OperatorType.notStartsWith;
        case r'EndsWith':
          return OperatorType.endsWith;
        case r'NotEndsWith':
          return OperatorType.notEndsWith;
        case r'Contains':
          return OperatorType.contains;
        case r'NotContains':
          return OperatorType.notContains;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OperatorTypeTypeTransformer] instance.
  static OperatorTypeTypeTransformer? _instance;
}
