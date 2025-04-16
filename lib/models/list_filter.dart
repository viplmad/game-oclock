import 'models.dart' show SearchDTO;

final class ListSearch {
  final String name;
  final SearchDTO search;

  ListSearch({required this.name, required this.search});

  ListSearch copyWith({final int? page, final int? size}) {
    return ListSearch(
      name: name,
      search: search.copyWith(page: page, size: size),
    );
  }
}
