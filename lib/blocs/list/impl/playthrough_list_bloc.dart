import 'package:game_oclock/models/models.dart'
    show PageResultDTO, Playthrough, SearchDTO;
import 'package:game_oclock/services/services.dart' show PlaythroughService;

import '../list.dart' show ListLoadBloc;

class PlaythroughListBloc extends ListLoadBloc<Playthrough> {
  PlaythroughListBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<PageResultDTO<Playthrough>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchForGame(search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countForGame(search, quicksearch);
}
