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
}
