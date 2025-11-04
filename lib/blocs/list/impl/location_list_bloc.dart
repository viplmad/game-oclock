import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart'
    show Location, LocationWithDate, SearchDTO;
import 'package:game_oclock/services/services.dart' show LocationService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class LocationListBloc extends ListLoadBloc<Location> {
  LocationListBloc({required this.service});

  final LocationService service;

  @override
  Future<ListFinal<Location>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<Location>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.search(search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.count(search, quicksearch),
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

class LocationAvailableListBloc extends ListLoadBloc<LocationWithDate> {
  LocationAvailableListBloc({required this.service, required this.gameId});

  final LocationService service;
  final String gameId;

  @override
  Future<ListFinal<LocationWithDate>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<LocationWithDate>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchAvailable(gameId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.countAvailable(gameId, search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<LocationWithDate>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
