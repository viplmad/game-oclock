import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show GameSession, SearchDTO;
import 'package:game_oclock/services/services.dart' show GameSessionService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class SessionListBloc extends ListLoadBloc<GameSession> {
  SessionListBloc({required this.service});

  final GameSessionService service;

  @override
  Future<ListFinal<GameSession>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<GameSession>? lastData,
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
    return ListLoadSuccess<GameSession>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class GameSessionListBloc extends ListLoadBloc<GameSession> {
  GameSessionListBloc({required this.service, required this.gameId});

  final GameSessionService service;
  final String gameId;

  @override
  Future<ListFinal<GameSession>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<GameSession>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchForGame(gameId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.countForGame(gameId, search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<GameSession>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
