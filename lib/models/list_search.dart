import 'models.dart' show SearchDTO;

final class ListSearch {
  final String name;
  final SearchDTO search;

  ListSearch.def() : this(name: '-', search: SearchDTO());
  const ListSearch({required this.name, required this.search});

  ListSearch copyWith({final int? page, final int? size}) {
    return ListSearch(
      name: name,
      search: search.copyWith(page: page, size: size),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'name'] = name;
    json[r'search'] = search;
    return json;
  }

  static ListSearch fromJson(final dynamic value) {
    final json = value.cast<String, dynamic>();

    return ListSearch(
      name: json[r'name']!,
      search: SearchDTO.fromJson(json[r'search'])!,
    );
  }
}
