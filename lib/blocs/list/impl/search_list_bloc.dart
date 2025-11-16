import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;
import 'package:game_oclock/services/services.dart' show ListSearchService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class SearchListBloc extends ListLoadBloc<ListSearch> {
  SearchListBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<ListFinal<ListSearch>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<ListSearch>? lastData,
    final int? lastTotal,
  ) async {
    final data = await service.getAll(space);
    return ListLoadSuccess<ListSearch>(
      data: List.unmodifiable(data),
      total: data.length, // Everything has been "fetched"
      quicksearch: quicksearch,
      search: search,
    );
  }
}
