import 'package:game_oclock/models/models.dart' show AggregateSearch;
import 'package:game_oclock/services/services.dart' show LocationService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class LocationListBloc extends ListLoadBloc<LocationDTO> {
  LocationListBloc({required this.service});

  final LocationService service;

  @override
  Future<PageResultDTO<LocationDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.count(AggregateSearch(filter: search.filter), quicksearch);
}

class LocationAvailableListBloc extends ListLoadBloc<LocationAvailableDTO> {
  LocationAvailableListBloc({required this.service, required this.gameId});

  final LocationService service;
  final String gameId;

  @override
  Future<PageResultDTO<LocationAvailableDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchAvailable(gameId, search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.countAvailable(
        gameId,
        AggregateSearch(filter: search.filter),
        quicksearch,
      );
}
