import 'package:game_oclock/models/models.dart'
    show PageResultDTO, SearchDTO, UserGame, UserGameWithDate;
import 'package:game_oclock/services/services.dart' show GameService;

import '../list.dart' show ListLoadBloc;

class UserGameListBloc extends ListLoadBloc<UserGame> {
  UserGameListBloc({required this.service});

  final GameService service;

  @override
  Future<PageResultDTO<UserGame>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.count(search, quicksearch);
}

class UserGameAvailableListBloc extends ListLoadBloc<UserGameWithDate> {
  UserGameAvailableListBloc({required this.service, required this.locationId});

  final GameService service;
  final String locationId;

  @override
  Future<PageResultDTO<UserGameWithDate>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchAvailable(locationId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countAvailable(locationId, search, quicksearch);
}

class UserGameWithTagListBloc extends ListLoadBloc<UserGame> {
  UserGameWithTagListBloc({required this.service, required this.tagId});

  final GameService service;
  final String tagId;

  @override
  Future<PageResultDTO<UserGame>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchWithTag(tagId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countWithTag(tagId, search, quicksearch);
}

class UserGamePlayedOnDeviceListBloc extends ListLoadBloc<UserGame> {
  UserGamePlayedOnDeviceListBloc({
    required this.service,
    required this.deviceId,
  });

  final GameService service;
  final String deviceId;

  @override
  Future<PageResultDTO<UserGame>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchPlayedOnDevice(deviceId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countPlayedOnDevice(deviceId, search, quicksearch);
}

class UserGameWithPlaythroughListBloc extends ListLoadBloc<UserGame> {
  UserGameWithPlaythroughListBloc({
    required this.service,
    required this.playthroughId,
  });

  final GameService service;
  final String playthroughId;

  @override
  Future<PageResultDTO<UserGame>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchWithPlaythrough(playthroughId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countWithPlaythrough(playthroughId, search, quicksearch);
}
