import 'package:game_oclock/data/services/igdb_service.dart';
import 'package:game_oclock/models/models.dart' show ExternalGame, ListSearch;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class ExternalGameListBloc extends ListLoadBloc<ExternalGame> {
  ExternalGameListBloc({required this.igdbService}) : super();

  final IGDBService igdbService;

  @override
  Future<ListFinal<ExternalGame>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<ExternalGame>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    if (quicksearch == null || quicksearch.isEmpty) {
      return ListLoadSuccess<ExternalGame>(
        data: [],
        quicksearch: quicksearch,
        search: search,
      );
    }
    final data = await igdbService.search(quicksearch);

    return ListLoadSuccess<ExternalGame>(
      data: data,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
