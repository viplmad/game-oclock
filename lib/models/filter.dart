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

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (chainOperator != null) {
      json[r'chain_operator'] = chainOperator!.toJson();
    }
    json[r'field'] = field;
    json[r'operator'] = operator_.toJson();
    json[r'value'] = value.toJson();
    return json;
  }

  static FilterDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return FilterDTO(
        chainOperator: ChainOperatorType.fromJson(json[r'chain_operator']),
        field: json[r'field']!,
        operator_: OperatorType.fromJson(json[r'operator'])!,
        value: SearchValue.fromJson(json[r'value'])!,
      );
    }
    return null;
  }

  static List<FilterDTO> listFromJson(dynamic json, {bool growable = false}) {
    final result = <FilterDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FilterDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}
