import 'package:game_oclock/models/models.dart'
    show ListSearch, PageResultDTO, SearchDTO;
import 'package:game_oclock/services/services.dart' show ListSearchService;

import '../list.dart' show ListLoadBloc;

class SearchListBloc extends ListLoadBloc<ListSearch> {
  SearchListBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<PageResultDTO<ListSearch>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) async => PageResultDTO(data: await service.getAll(space));

  @override
  Future<int?> doCount(
    final SearchDTO search,
    final String? quicksearch,
  ) async => null;
}
