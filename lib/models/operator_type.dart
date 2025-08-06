import 'package:flutter/material.dart';

List<DropdownMenuEntry<String>> operatorsMenuEntries = List.unmodifiable([
  const DropdownMenuEntry<String>(value: 'Eq', label: 'Equal'),
  const DropdownMenuEntry<String>(value: 'NotEq', label: 'Not equal'),
  const DropdownMenuEntry<String>(value: 'Gt', label: 'Greater than'),
  const DropdownMenuEntry<String>(value: 'Gte', label: 'Greater than or equal'),
  const DropdownMenuEntry<String>(value: 'Lt', label: 'Less than'),
  const DropdownMenuEntry<String>(value: 'Lte', label: 'Less than or equal'),
  const DropdownMenuEntry<String>(value: 'StartsWith', label: 'Starts with'),
  const DropdownMenuEntry<String>(
    value: 'NotStartsWith',
    label: 'Does not start with',
  ),
  const DropdownMenuEntry<String>(value: 'EndsWith', label: 'Ends with'),
  const DropdownMenuEntry<String>(
    value: 'NotEndsWith',
    label: 'Does not end with',
  ),
  const DropdownMenuEntry<String>(value: 'Contains', label: 'Contains'),
  const DropdownMenuEntry<String>(
    value: 'NotContains',
    label: 'Does not contain',
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
