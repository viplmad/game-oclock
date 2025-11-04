import 'models.dart' show OrderType;

class SortDTO {
  /// Returns a new [SortDTO] instance.
  SortDTO({required this.field, required this.order});

  String field;

  OrderType order;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'field'] = field;
    json[r'order'] = order.toJson();
    return json;
  }

  static SortDTO? fromJson(final dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return SortDTO(
        field: json[r'field']!,
        order: OrderType.fromJson(json[r'order'])!,
      );
    }
    return null;
  }

  static List<SortDTO> listFromJson(
    final dynamic json, {
    final bool growable = false,
  }) {
    final result = <SortDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SortDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}
