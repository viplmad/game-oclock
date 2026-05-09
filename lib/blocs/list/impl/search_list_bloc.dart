import 'package:game_oclock/blocs/default_search.dart';
import 'package:game_oclock/models/models.dart'
    show GameOClockException, ListSearch, errorCodeNotFound;
import 'package:game_oclock/services/services.dart' show ListSearchService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class SearchListBloc extends ListLoadBloc<ListSearch> {
  SearchListBloc({required this.service, required this.space});

  final ListSearchService service;
  final String space;

  @override
  Future<PageResultDTO<ListSearch>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async {
    final data = await getAllOrEmpty();
    final defaultData = defaultListSearch[space] ?? [];
    return PageResultDTO(data: [...defaultData, ...data], page: 0, size: 500);
  }

  Future<List<ListSearch>> getAllOrEmpty() async {
    try {
      return await service.getAll(space);
    } on GameOClockException catch (e) {
      if (e.code == errorCodeNotFound) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<int?> doCount(
    final ListSearchDTO search,
    final String? quicksearch,
  ) async => null;
}
