import 'package:game_oclock/services/services.dart' show DeviceService;
import 'package:game_oclock_client/api.dart';

import '../list.dart' show ListLoadBloc;

class DeviceListBloc extends ListLoadBloc<DeviceDTO> {
  DeviceListBloc({required this.service});

  final DeviceService service;

  @override
  Future<PageResultDTO<DeviceDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.search(search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.count(search, quicksearch);
}

class DevicePlayedGameListBloc extends ListLoadBloc<DeviceDTO> {
  DevicePlayedGameListBloc({required this.service, required this.gameId});

  final DeviceService service;
  final String gameId;

  @override
  Future<PageResultDTO<DeviceDTO>> doLoad(
    final ListSearchDTO search,
    final String? quicksearch,
  ) => service.searchPlayed(gameId, search, quicksearch);

  @override
  Future<int> doCount(final ListSearchDTO search, final String? quicksearch) =>
      service.countPlayed(gameId, search, quicksearch);
}
