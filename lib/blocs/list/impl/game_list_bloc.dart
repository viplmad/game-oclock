import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart'
    show SearchDTO, UserGame, UserGameWithDate;
import 'package:game_oclock/services/services.dart' show GameService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class UserGameListBloc extends ListLoadBloc<UserGame> {
  UserGameListBloc({required this.service});

  final GameService service;

  @override
  Future<ListFinal<UserGame>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<UserGame>? lastData,
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
    return ListLoadSuccess<UserGame>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class UserGameAvailableListBloc extends ListLoadBloc<UserGameWithDate> {
  UserGameAvailableListBloc({required this.service, required this.locationId});

  final GameService service;
  final String locationId;

  @override
  Future<ListFinal<UserGameWithDate>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<UserGameWithDate>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchAvailable(locationId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () =>
          service.countAvailable(locationId, search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<UserGameWithDate>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class UserGameWithTagListBloc extends ListLoadBloc<UserGame> {
  UserGameWithTagListBloc({required this.service, required this.tagId});

  final GameService service;
  final String tagId;

  @override
  Future<ListFinal<UserGame>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<UserGame>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchWithTag(tagId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.countWithTag(tagId, search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<UserGame>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class UserGamePlayedOnDeviceListBloc extends ListLoadBloc<UserGame> {
  UserGamePlayedOnDeviceListBloc({
    required this.service,
    required this.deviceId,
  });

  final GameService service;
  final String deviceId;

  @override
  Future<ListFinal<UserGame>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<UserGame>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchPlayedOnDevice(deviceId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () =>
          service.countPlayedOnDevice(deviceId, search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<UserGame>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
