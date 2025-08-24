import 'package:game_oclock/models/models.dart' show ListSearch, PageResultDTO;

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

    final page = search.search.page ?? 0;
    final size = search.search.size ?? 50; // TODO Set in bloc?
    final data = PageResultDTO(
      data: List.generate(size, (final index) {
        final finalIndex = (page * size) + index;
        return DateTime.now().subtract(Duration(hours: finalIndex));
      }),
      page: page,
      size: size,
    );

    return ListLoadSuccess<DateTime>(
      data: List.of(
        lastData == null ? data.data : [...lastData, ...data.data],
        growable: false,
      )..sort((final a, final b) => a.compareTo(b)), // Sort to simplify computation on UI
      quicksearch: quicksearch,
      search: search,
    );
  }
}
