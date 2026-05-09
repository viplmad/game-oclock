import 'package:game_oclock/services/services.dart' show TagService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class TagListBloc extends ListLoadBloc<TagDTO> {
  TagListBloc({required this.service});

  final TagService service;

  @override
  Future<PageResultDTO<TagDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.count(search, quicksearch);
}

class TagOfGameListBloc extends ListLoadBloc<TagMediaDTO> {
  TagOfGameListBloc({required this.service, required this.gameId});

  final TagService service;
  final String gameId;

  @override
  Future<PageResultDTO<TagMediaDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchMediaTags(gameId, search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.countMediaTags(gameId, search, quicksearch);
}
