import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart'
    show GameAvailable, ListSearch, Tag, UserGame;
import 'package:game_oclock/services/services.dart' show GameService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class UserGameListBloc extends ListLoadBloc<UserGame> {
  UserGameListBloc({required this.service});

  final GameService service;

  @override
  Future<ListFinal<UserGame>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<UserGame>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.search(search.search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.count(search.search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<UserGame>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class UserGameTagListBloc extends ListLoadBloc<Tag> {
  UserGameTagListBloc({required this.service, required this.gameId});

  final GameService service;
  final String gameId;

  @override
  Future<ListFinal<Tag>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<Tag>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchTags(gameId, search.search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.countTags(gameId, search.search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<Tag>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class UserGameAvailableListBloc extends ListLoadBloc<GameAvailable> {
  UserGameAvailableListBloc({required this.service, required this.gameId});

  final GameService service;
  final String gameId;

  @override
  Future<ListFinal<GameAvailable>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<GameAvailable>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchAvailable(gameId, search.search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () =>
          service.countAvailable(gameId, search.search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<GameAvailable>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
