import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart'
    show SearchDTO, Tag, UserGame, UserGameWithDate;
import 'package:game_oclock/services/services.dart' show GameService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class UserGameListBloc extends ListLoadBloc<UserGame> {
  UserGameListBloc({required this.service});

  final GameService service;

  @override
  Future<ListFinal<UserGame>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<UserGame>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.search(search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.count(search, quicksearch),
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
    final SearchDTO search,
    final List<Tag>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchTags(gameId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.countTags(gameId, search, quicksearch),
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

class UserGameAvailableListBloc extends ListLoadBloc<UserGameWithDate> {
  UserGameAvailableListBloc({required this.service, required this.locationId});

  final GameService service;
  final String locationId;

  @override
  Future<ListFinal<UserGameWithDate>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<UserGameWithDate>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchAvailable(locationId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () =>
          service.countAvailable(locationId, search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<UserGameWithDate>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
