import 'package:game_oclock/models/models.dart'
    show Location, LocationWithDate, PageResultDTO, SearchDTO;
import 'package:game_oclock/services/services.dart' show LocationService;

import '../list.dart' show ListLoadBloc;

class LocationListBloc extends ListLoadBloc<Location> {
  LocationListBloc({required this.service});

  final LocationService service;

  @override
  Future<PageResultDTO<Location>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.count(search, quicksearch);
}

class LocationAvailableListBloc extends ListLoadBloc<LocationWithDate> {
  LocationAvailableListBloc({required this.service, required this.gameId});

  final LocationService service;
  final String gameId;

  @override
  Future<PageResultDTO<LocationWithDate>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchAvailable(gameId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countAvailable(gameId, search, quicksearch);
}
