import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show Device, SearchDTO;
import 'package:game_oclock/services/services.dart' show DeviceService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class DeviceListBloc extends ListLoadBloc<Device> {
  DeviceListBloc({required this.service});

  final DeviceService service;

  @override
  Future<ListFinal<Device>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<Device>? lastData,
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
    return ListLoadSuccess<Device>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}

class DevicePlayedGameListBloc extends ListLoadBloc<Device> {
  DevicePlayedGameListBloc({required this.service, required this.gameId});

  final DeviceService service;
  final String gameId;

  @override
  Future<ListFinal<Device>> loadList(
    final String? quicksearch,
    final SearchDTO search,
    final List<Device>? lastData,
    final int? lastTotal,
  ) async {
    final data = mergePageData(
      search: search,
      page: await service.searchPlayed(gameId, search, quicksearch),
      lastData: lastData,
    );
    final count = await mergeCount(
      search: search,
      countGetter: () => service.countPlayed(gameId, search, quicksearch),
      lastTotal: lastTotal,
    );
    return ListLoadSuccess<Device>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
