import 'package:game_oclock/models/models.dart' show FilterFormData, ListSearch;
import 'package:game_oclock/services/services.dart' show SearchService;

import '../list.dart'
    show ListFinal, ListLoadBloc, ListLoadSuccess, LocalEditableListBloc;

class SearchListBloc extends ListLoadBloc<ListSearch> {
  SearchListBloc({required this.service, required this.space});

  final SearchService service;
  final String space;

  @override
  Future<ListFinal<ListSearch>> loadList(
    final String? quicksearch,
    final ListSearch search,
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

class FilterFormDataListBloc extends LocalEditableListBloc<FilterFormData> {
  FilterFormDataListBloc({required super.data});
}
