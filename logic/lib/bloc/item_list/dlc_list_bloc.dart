import 'package:game_oclock_client/api.dart'
    show DLCDTO, DLCPageResult, DLCWithFinishPageResult, NewDLCDTO;

import 'package:logic/model/model.dart' show DLCView;
import 'package:logic/service/service.dart'
    show DLCService, DLCFinishService, GameOClockService;

import 'item_list.dart';

class DLCListBloc extends ItemListBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCListBloc({
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _dlcFinishService = collectionService.dlcFinishService,
        super(service: collectionService.dlcService);

  final DLCFinishService _dlcFinishService;

  @override
  Future<List<DLCDTO>> getAllWithView(
    int viewIndex,
    Object? viewArgs, [
    int? page,
  ]) async {
    final DLCView view = DLCView.values[viewIndex];
    switch (view) {
      case DLCView.main:
        final DLCPageResult result = await service.getAll(page: page);
        return result.data;
      case DLCView.lastAdded:
        final DLCPageResult result = await service.getLastAdded(page: page);
        return result.data;
      case DLCView.lastUpdated:
        final DLCPageResult result = await service.getLastUpdated(page: page);
        return result.data;
      case DLCView.lastFinished:
        // null startDate = since the beginning of time
        final DLCWithFinishPageResult result = await _dlcFinishService
            .getLastFinishedDLCs(null, DateTime.now(), page: page);
        return result.data;
    }
  }
}
