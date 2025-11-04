class SearchValue {
  /// Returns a new [SearchValue] instance.
  SearchValue({this.value, this.values});

  String? value;

  List<String>? values;

  dynamic toJson() {
    if (value != null) {
      return value;
    } else if (values != null) {
      return values;
    }
    return null;
  }

  static SearchValue? fromJson(final dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return SearchValue(
        value: json[r'Value'],
        values: json[r'Values'] is List
            ? (json[r'Values'] as List).cast<String>()
            : const [],
      );
    }
    return null;
  }
}
