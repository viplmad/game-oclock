import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show GamePlaythrough, PageResultDTO, SearchDTO;

class GamePlaythroughService {
  Future<PageResultDTO<GamePlaythrough>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockGamePlaythrough(name: 'name ($quicksearch) $index'),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<PageResultDTO<GamePlaythrough>> searchForGame(
    final String gameId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockGamePlaythrough(name: 'name ($quicksearch) $index'),
    );
  }

  Future<int> countForGame(
    final String gameId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<GamePlaythrough> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockGamePlaythrough();
  }

  Future<GamePlaythrough> create(final GamePlaythrough playthrough) async {
    await Future.delayed(const Duration(seconds: 5));
    return playthrough;
  }

  Future<void> update(final GamePlaythrough playthrough) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
