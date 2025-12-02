import 'package:game_oclock/models/models.dart'
    show GamePlaythrough, PageResultDTO, SearchDTO;
import 'package:game_oclock/services/services.dart' show GamePlaythroughService;

import '../list.dart' show ListLoadBloc;

class GamePlaythroughListBloc extends ListLoadBloc<GamePlaythrough> {
  GamePlaythroughListBloc({required this.service, required this.gameId});

  final GamePlaythroughService service;
  final String gameId;

  @override
  Future<PageResultDTO<GamePlaythrough>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchForGame(gameId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countForGame(gameId, search, quicksearch);
}
