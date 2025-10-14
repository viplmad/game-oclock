import 'package:game_oclock/blocs/bloc_utils.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, Device;
import 'package:game_oclock/services/services.dart' show DeviceService;

import '../list.dart' show ListFinal, ListLoadBloc, ListLoadSuccess;

class DeviceListBloc extends ListLoadBloc<Device> {
  DeviceListBloc({required this.service});

  final DeviceService service;

  @override
  Future<ListFinal<Device>> loadList(
    final String? quicksearch,
    final ListSearch search,
    final List<Device>? lastData,
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
    return ListLoadSuccess<Device>(
      data: data,
      total: count,
      quicksearch: quicksearch,
      search: search,
    );
  }
}
