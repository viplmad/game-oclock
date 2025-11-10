import 'models.dart' show FilterDTO, SortDTO;

class SearchDTO {
  /// Returns a new [SearchDTO] instance.
  SearchDTO({
    this.filter = const [],
    this.page,
    this.size,
    this.sort = const [],
  });

  List<FilterDTO>? filter;

  /// Minimum value: 0
  int? page;

  /// Minimum value: 0
  int? size;

  List<SortDTO>? sort;

  SearchDTO copyWith({
    final List<FilterDTO>? filter,
    final int? page,
    final int? size,
    final List<SortDTO>? sort,
  }) {
    return SearchDTO(
      filter: filter ?? this.filter,
      page: page ?? this.page,
      size: size ?? this.size,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (filter != null) {
      json[r'filter'] = filter!
          .map((final e) => e.toJson())
          .toList(growable: false);
    }
    if (page != null) {
      json[r'page'] = page;
    }
    if (size != null) {
      json[r'size'] = size;
    }
    if (sort != null) {
      json[r'sort'] = sort!
          .map((final e) => e.toJson())
          .toList(growable: false);
    }
    return json;
  }

  static SearchDTO? fromJson(final dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return SearchDTO(
        filter: FilterDTO.listFromJson(json[r'filter']),
        page: json[r'page'],
        size: json[r'size'],
        sort: SortDTO.listFromJson(json[r'sort']),
      );
    }
    return null;
  }
}
