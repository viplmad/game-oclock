import 'package:game_oclock/models/models.dart'
    show ExternalGame, PageResultDTO, SearchDTO;
import 'package:game_oclock/services/services.dart' show IGDBService;

import '../list.dart' show ListLoadBloc;

class ExternalGameListBloc extends ListLoadBloc<ExternalGame> {
  ExternalGameListBloc({required this.igdbService});

  final IGDBService igdbService;

  @override
  Future<PageResultDTO<ExternalGame>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    if (quicksearch == null || quicksearch.isEmpty) {
      return PageResultDTO(data: []);
    }

    return PageResultDTO(data: await igdbService.search(quicksearch));
  }

  @override
  Future<int?> doCount(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    if (quicksearch == null || quicksearch.isEmpty) {
      return 0;
    }

    return null;
  }
}
