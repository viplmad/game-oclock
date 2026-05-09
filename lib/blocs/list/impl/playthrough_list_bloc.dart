import 'package:game_oclock/models/models.dart' show Playthrough;
import 'package:game_oclock/services/services.dart' show PlaythroughService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class PlaythroughListBloc extends ListLoadBloc<Playthrough> {
  PlaythroughListBloc({required this.service});

  final PlaythroughService service;

  @override
  Future<PageResultDTO<Playthrough>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchForGame(search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.countForGame(search, quicksearch);
}
