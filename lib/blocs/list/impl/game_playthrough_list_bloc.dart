import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart'
    show GamePlaythrough, ListSearch;
import 'package:game_oclock/services/services.dart' show GamePlaythroughService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class GamePlaythroughListBloc extends ListLoadBloc<GamePlaythrough> {
  GamePlaythroughListBloc({required this.service, required this.gameId});

  final GamePlaythroughService service;
  final String gameId;

  @override
  Future<ListFinal<GamePlaythrough>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<GamePlaythrough>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchForGame(gameId, search.search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () =>
          service.countForGame(gameId, search.search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<GamePlaythrough>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
