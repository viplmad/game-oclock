import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;

class SearchService {
  Future<List<ListSearch>> getAll(final String space) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(5, (final index) {
      final finalIndex = index;
      return mockSearch(
        name: 'search $space $finalIndex',
        filters: 2,
        sorts: 1,
      );
    });
  }

  Future<ListSearch> get(final String space, final String name) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockSearch(name: space + name, filters: 3);
  }

  Future<void> create(final String space, final ListSearch name) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> update(final String space, final ListSearch search) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
