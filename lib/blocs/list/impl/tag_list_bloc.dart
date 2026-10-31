import 'package:game_oclock/models/models.dart' show AggregateSearch;
import 'package:game_oclock/services/services.dart' show TagService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class TagListBloc extends ListLoadBloc<TagDTO> {
  TagListBloc({required this.service});

  final TagService service;

  @override
  Future<PageResultDTO<TagDTO>> doLoad(
    ListSearchDTO search,
    String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(ListSearchDTO search, String? quicksearch) =>
      service.count(AggregateSearch(filter: search.filter), quicksearch);
}

class TagOfGameListBloc extends ListLoadBloc<TagMediaDTO> {
  TagOfGameListBloc({required this.service, required this.gameId});

  final TagService service;
  final String gameId;

  @override
  Future<PageResultDTO<TagMediaDTO>> doLoad(
    ListSearchDTO search,
    String? quicksearch,
  ) => service.searchMediaTags(gameId, search, quicksearch);

  @override
  Future<int> doCount(ListSearchDTO search, String? quicksearch) =>
      service.countMediaTags(
        gameId,
        AggregateSearch(filter: search.filter),
        quicksearch,
      );
}
