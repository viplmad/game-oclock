import 'package:game_oclock/models/models.dart'
    show PageResultDTO, SearchDTO, Tag;
import 'package:game_oclock/services/services.dart' show TagService;

import '../list.dart' show ListLoadBloc;

class TagListBloc extends ListLoadBloc<Tag> {
  TagListBloc({required this.service});

  final TagService service;

  @override
  Future<PageResultDTO<Tag>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.count(search, quicksearch);
}

class TagOfGameListBloc extends ListLoadBloc<Tag> {
  TagOfGameListBloc({required this.service, required this.gameId});

  final TagService service;
  final String gameId;

  @override
  Future<PageResultDTO<Tag>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchGameTags(gameId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countGameTags(gameId, search, quicksearch);
}
