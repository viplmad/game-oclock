class ChainOperatorType {
  /// Instantiate a new enum with the provided [value].
  const ChainOperatorType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  static const and = ChainOperatorType._(r'And');
  static const or = ChainOperatorType._(r'Or');
}
