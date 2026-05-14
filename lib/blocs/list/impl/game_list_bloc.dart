import 'package:game_oclock/models/models.dart' show AggregateSearch;
import 'package:game_oclock/services/services.dart' show GameService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class UserGameListBloc extends ListLoadBloc<MediaDTO> {
  UserGameListBloc({required this.service});

  final GameService service;

  @override
  Future<PageResultDTO<MediaDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.count(AggregateSearch(filter: search.filter), quicksearch);
}

class UserGameAvailableListBloc extends ListLoadBloc<MediaAvailableDTO> {
  UserGameAvailableListBloc({required this.service, required this.locationId});

  final GameService service;
  final String locationId;

  @override
  Future<PageResultDTO<MediaAvailableDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchAvailable(locationId, search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.countAvailable(
        locationId,
        AggregateSearch(filter: search.filter),
        quicksearch,
      );
}

class UserGameWithTagListBloc extends ListLoadBloc<MediaTagDTO> {
  UserGameWithTagListBloc({required this.service, required this.tagId});

  final GameService service;
  final String tagId;

  @override
  Future<PageResultDTO<MediaTagDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchWithTag(tagId, search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.countWithTag(
        tagId,
        AggregateSearch(filter: search.filter),
        quicksearch,
      );
}

class UserGamePlayedOnDeviceListBloc extends ListLoadBloc<MediaDTO> {
  UserGamePlayedOnDeviceListBloc({
    required this.service,
    required this.deviceId,
  });

  final GameService service;
  final String deviceId;

  @override
  Future<PageResultDTO<MediaDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchPlayedOnDevice(deviceId, search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.countPlayedOnDevice(
        deviceId,
        AggregateSearch(filter: search.filter),
        quicksearch,
      );
}

class UserGameWithPlaythroughListBloc extends ListLoadBloc<MediaDTO> {
  UserGameWithPlaythroughListBloc({
    required this.service,
    required this.playthroughId,
  });

  final GameService service;
  final String playthroughId;

  @override
  Future<PageResultDTO<MediaDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchWithPlaythrough(playthroughId, search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.countWithPlaythrough(playthroughId, search, quicksearch);
}
