import 'package:game_oclock/models/models.dart'
    show Device, PageResultDTO, SearchDTO;
import 'package:game_oclock/services/services.dart' show DeviceService;

import '../list.dart' show ListLoadBloc;

class DeviceListBloc extends ListLoadBloc<Device> {
  DeviceListBloc({required this.service});

  final DeviceService service;

  @override
  Future<PageResultDTO<Device>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.count(search, quicksearch);
}

class DevicePlayedGameListBloc extends ListLoadBloc<Device> {
  DevicePlayedGameListBloc({required this.service, required this.gameId});

  final DeviceService service;
  final String gameId;

  @override
  Future<PageResultDTO<Device>> doLoad(
    final SearchDTO search,
    final String? quicksearch,
  ) => service.searchPlayed(gameId, search, quicksearch);

  @override
  Future<int> doCount(final SearchDTO search, final String? quicksearch) =>
      service.countPlayed(gameId, search, quicksearch);
}
