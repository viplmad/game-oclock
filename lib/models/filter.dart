import 'models.dart' show ChainOperatorType, OperatorType, SearchValue;

class FilterDTO {
  /// Returns a new [FilterDTO] instance.
  FilterDTO({
    this.chainOperator,
    required this.field,
    required this.operator_,
    required this.value,
  });

  ChainOperatorType? chainOperator;

  String field;

  OperatorType operator_;

  SearchValue value;
}
