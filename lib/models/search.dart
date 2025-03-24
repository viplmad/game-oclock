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
}
