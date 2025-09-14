import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show ListSearch;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class GameLogListBloc extends ListLoadBloc<DateTime> {
  @override
  Future<ListFinal<DateTime>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<DateTime>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) => DateTime.now().subtract(Duration(hours: index)),
    );
    final data = mergePageData(search: search, page: page, lastData: lastData);

    return ListLoadSuccess<DateTime>(
      data: data
        ..sort(
          (final a, final b) => a.compareTo(b),
        ), // Sort to simplify computation on UI
      quicksearch: quicksearch,
      search: search,
      total: 500,
    );
  }
}
