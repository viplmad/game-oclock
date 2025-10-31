import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show PageResultDTO, SearchDTO, Tag;

class TagService {
  Future<PageResultDTO<Tag>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) => mockTag(name: 'name ($quicksearch) $index'),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<Tag> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockTag();
  }

  Future<Tag> create(final Tag tag) async {
    await Future.delayed(const Duration(seconds: 5));
    return tag;
  }

  Future<void> update(final Tag tag) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> delete(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
