import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show GameAvailable, PageResultDTO, SearchDTO, UserGame;
import 'package:game_oclock/models/tag.dart';

class GameService {
  Future<PageResultDTO<UserGame>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockUserGame(title: 'title ($quicksearch) $index'),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<PageResultDTO<GameAvailable>> searchAvailable(
    final String gameId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockGameAvailable(name: 'name $gameId ($quicksearch) $index'),
    );
  }

  Future<int> countAvailable(
    final String gameId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<PageResultDTO<Tag>> searchTags(
    final String gameId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockTag(name: 'name $gameId ($quicksearch) $index'),
    );
  }

  Future<int> countTags(
    final String gameId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<void> addTag(final String gameId, final String tagId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<UserGame> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockUserGame();
  }

  Future<void> create(final UserGame game) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> update(final UserGame game) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> delete(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
