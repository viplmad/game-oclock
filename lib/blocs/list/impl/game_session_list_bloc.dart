import 'package:game_oclock/services/services.dart' show GameSessionService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class SessionListBloc extends ListLoadBloc<SessionDTO> {
  SessionListBloc({required this.service});

  final GameSessionService service;

  @override
  Future<PageResultDTO<SessionDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int?> doCount(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async => null;
  /*service.count(AggregateSearch(filter: search.filter), quicksearch);*/
}

class GameSessionListBloc extends ListLoadBloc<SessionDTO> {
  GameSessionListBloc({required this.service, required this.gameId});

  final GameSessionService service;
  final String gameId;

  @override
  Future<PageResultDTO<SessionDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchForGame(gameId, search, quicksearch);

  @override
  Future<int?> doCount(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async => null;
  /*service.countForGame(
        gameId,
        AggregateSearch(filter: search.filter),
        quicksearch,
      );*/
}
