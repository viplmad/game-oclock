import 'package:game_oclock/blocs/list/list_state.dart';
import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, Tag;

import '../list.dart' show ListLoadBloc;

class TagListBloc extends ListLoadBloc<Tag> {
  @override
  Future<ListFinal<Tag>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<Tag>? lastData,
    final String? lastQuicksearch,
    final ListSearch? lastSearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final page = mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) => mockTag(name: 'name ($quicksearch) $index'),
    );
    final data = mergePageData(search: search, page: page, lastData: lastData);

    return ListLoadSuccess<Tag>(
      data: data,
      total: 500,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
