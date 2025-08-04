import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, PageResultDTO;

import 'list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class SearchListBloc extends ListLoadBloc<ListSearch> {
  SearchListBloc({required this.space});

  final String space;

  @override
  Future<ListFinal<ListSearch>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<ListSearch>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = search.search.page ?? 0;
    final size = search.search.size ?? 50; // TODO Set in bloc?
    final data = PageResultDTO(
      data: List.generate(size, (final index) {
        final finalIndex = (page * size) + index;
        return mockSearch(name: 'search $finalIndex');
      }),
      page: page,
      size: size,
    );

    return ListLoadSuccess<ListSearch>(
      data: List.of(
        lastData == null ? data.data : [...lastData, ...data.data],
        growable: false,
      ),
      quicksearch: quicksearch,
      search: search,
    );
  }
}
