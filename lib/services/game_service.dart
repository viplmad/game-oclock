import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show PageResultDTO, SearchDTO, UserGame, UserGameWithDate;

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

  Future<PageResultDTO<UserGameWithDate>> searchAvailable(
    final String locationId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) => mockUserGameWithDate(
        title: 'title $locationId ($quicksearch) $index',
      ),
    );
  }

  Future<int> countAvailable(
    final String locationId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<PageResultDTO<UserGame>> searchWithTag(
    final String tagId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockUserGame(title: 'title $tagId ($quicksearch) $index'),
    );
  }

  Future<int> countWithTag(
    final String tagId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<PageResultDTO<UserGame>> searchPlayedOnDevice(
    final String deviceId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockUserGame(title: 'title $deviceId ($quicksearch) $index'),
    );
  }

  Future<int> countPlayedOnDevice(
    final String deviceId,
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<void> addAvailability(
    final String gameId,
    final String locationId,
    final DateTime date,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> addTag(final String gameId, final String tagId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<UserGame> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockUserGame();
  }

  Future<UserGame> create(final UserGame game) async {
    await Future.delayed(const Duration(seconds: 1));
    return game;
  }

  Future<void> update(final UserGame game) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> delete(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
