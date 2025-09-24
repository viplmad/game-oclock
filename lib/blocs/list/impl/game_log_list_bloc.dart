import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;
import 'package:game_oclock/services/services.dart' show GameLogService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class GameLogListBloc extends ListLoadBloc<DateTime> {
  GameLogListBloc({required this.service});

  final GameLogService service;

  @override
  Future<ListFinal<DateTime>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<DateTime>? lastData,
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
    return ListLoadSuccess<DateTime>(
      data: data
        ..sort(
          (final a, final b) => a.compareTo(b),
        ), // Sort to simplify computation on UI
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
