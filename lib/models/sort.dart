import 'models.dart' show OrderType;

class SortDTO {
  /// Returns a new [SortDTO] instance.
  SortDTO({required this.field, required this.order});

  String field;

  OrderType order;
}
