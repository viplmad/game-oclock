import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, Tag;
import 'package:game_oclock/services/services.dart' show TagService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class TagListBloc extends ListLoadBloc<Tag> {
  TagListBloc({required this.service});

  final TagService service;

  @override
  Future<ListFinal<Tag>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<Tag>? lastData,
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
    return ListLoadSuccess<Tag>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
