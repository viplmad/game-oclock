import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show SearchDTO, Tag;
import 'package:game_oclock/services/services.dart' show TagService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class TagListBloc extends ListLoadBloc<Tag> {
  TagListBloc({required this.service});

  final TagService service;

  @override
  Future<ListFinal<Tag>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<Tag>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.search(search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.count(search, quicksearch),
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

class TagOfGameListBloc extends ListLoadBloc<Tag> {
  TagOfGameListBloc({required this.service, required this.gameId});

  final TagService service;
  final String gameId;

  @override
  Future<ListFinal<Tag>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<Tag>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchGameTags(gameId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.countGameTags(gameId, search, quicksearch),
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
