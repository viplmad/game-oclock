import 'package:game_oclock/blocs/list/list_state.dart';
import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show GameAvailable, ListSearch, Tag, UserGame;

import '../list.dart' show ListLoadBloc;

class UserGameListBloc extends ListLoadBloc<UserGame> {
  @override
  Future<ListFinal<UserGame>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<UserGame>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder:
          (final index) => mockUserGame(title: 'title ($quicksearch) $index'),
    );
    final data = mergePageData(search: search, page: page, lastData: lastData);

    return ListLoadSuccess<UserGame>(
      data: data,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class UserGameTagListBloc extends ListLoadBloc<Tag> {
  UserGameTagListBloc({required this.gameId});

  final String gameId;

  @override
  Future<ListFinal<Tag>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<Tag>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder:
          (final index) => mockTag(name: 'name $gameId ($quicksearch) $index'),
    );
    final data = mergePageData(search: search, page: page, lastData: lastData);

    return ListLoadSuccess<Tag>(
      data: data,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class UserGameAvailableListBloc extends ListLoadBloc<GameAvailable> {
  UserGameAvailableListBloc({required this.gameId});

  final String gameId;

  @override
  Future<ListFinal<GameAvailable>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<GameAvailable>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder:
          (final index) =>
              mockGameAvailable(name: 'name $gameId ($quicksearch) $index'),
    );
    final data = mergePageData(search: search, page: page, lastData: lastData);

    return ListLoadSuccess<GameAvailable>(
      data: data,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
