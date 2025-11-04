class SearchValue {
  /// Returns a new [SearchValue] instance.
  SearchValue({this.value, this.values});

  String? value;

  List<String>? values;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (value != null) {
      json[r'value'] = value;
    }
    if (values != null) {
      json[r'values'] = values;
    }
    return json;
  }

  static SearchValue? fromJson(final dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return SearchValue(
        value: json[r'value'],
        values: json[r'values'] is List
            ? (json[r'values'] as List).cast<String>()
            : const [],
      );
    }
    return null;
  }
}
