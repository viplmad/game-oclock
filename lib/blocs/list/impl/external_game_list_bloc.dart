import 'package:game_oclock/models/models.dart'
    show ExternalGame, PageResultDTO, SearchDTO;
import 'package:game_oclock/services/services.dart' show ExternalGameService;

import '../list.dart' show ListLoadBloc;

class ExternalGameListBloc extends ListLoadBloc<ExternalGame> {
  ExternalGameListBloc({required this.service});

  final ExternalGameService service;

  @override
  Future<PageResultDTO<ExternalGame>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int?> doCount(
    final SearchDTO search,
    final String? quicksearch,
  ) async => null;
}
