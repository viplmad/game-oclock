import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show PageResultDTO, Playthrough, SearchDTO;

class PlaythroughService {
  Future<PageResultDTO<Playthrough>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockPlaythrough(name: 'name ($quicksearch) $index'),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<PageResultDTO<Playthrough>> searchForGame(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockPlaythrough(name: 'name ($quicksearch) $index'),
    );
  }

  Future<int> countForGame(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<Playthrough> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPlaythrough();
  }

  Future<Playthrough> create(final Playthrough playthrough) async {
    await Future.delayed(const Duration(seconds: 5));
    return playthrough;
  }

  Future<void> update(final Playthrough playthrough) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> delete(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
