import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show GameSession, PageResultDTO, SearchDTO;

class GameSessionService {
  Future<PageResultDTO<GameSession>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockGameSession(name: 'name ($quicksearch) $index'),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<PageResultDTO<GameSession>> searchForGame(
    final String gameId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockGameSession(name: 'name ($quicksearch) $index'),
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

  Future<GameSession> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockGameSession();
  }

  Future<void> create(final GameSession session) async {
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<void> update(final GameSession session) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
