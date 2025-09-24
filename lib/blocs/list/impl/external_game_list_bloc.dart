import 'package:game_oclock/models/models.dart' show ExternalGame, ListSearch;
import 'package:game_oclock/services/services.dart' show IGDBService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class ExternalGameListBloc extends ListLoadBloc<ExternalGame> {
  ExternalGameListBloc({required this.igdbService});

  final IGDBService igdbService;

  @override
  Future<ListFinal<ExternalGame>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<ExternalGame>? lastData,
    final int? lastTotal,
  ) async {
    if (quicksearch == null || quicksearch.isEmpty) {
      return ListLoadSuccess<ExternalGame>(
        data: [],
        total: 0,
        quicksearch: quicksearch,
        search: search,
      );
    }

    final data = await igdbService.search(quicksearch);
    return ListLoadSuccess<ExternalGame>(
      data: data,
      total: data.length, // Avoid searching more data
      quicksearch: quicksearch,
      search: search,
    );
  }
}
