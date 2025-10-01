import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, Location;
import 'package:game_oclock/services/services.dart' show LocationService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class LocationListBloc extends ListLoadBloc<Location> {
  LocationListBloc({required this.service});

  final LocationService service;

  @override
  Future<ListFinal<Location>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<Location>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.search(search.search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.count(search.search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<Location>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
