import 'package:game_oclock/models/models.dart'
    show GameSession, PageResultDTO, SearchDTO;
import 'package:game_oclock/services/services.dart' show GameSessionService;

import '../list.dart' show ListLoadBloc;

class SessionListBloc extends ListLoadBloc<GameSession> {
  SessionListBloc({required this.service});

  final GameSessionService service;

  @override
  Future<PageResultDTO<GameSession>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.count(search, quicksearch);
}

class GameSessionListBloc extends ListLoadBloc<GameSession> {
  GameSessionListBloc({required this.service, required this.gameId});

  final GameSessionService service;
  final String gameId;

  @override
  Future<PageResultDTO<GameSession>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchForGame(gameId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countForGame(gameId, search, quicksearch);
}
