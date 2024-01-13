import 'package:game_oclock_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:logic/service/service.dart'
    show DLCFinishService, DLCService, GameOClockService;

import 'item_detail.dart';

class DLCDetailBloc extends ItemDetailBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCDetailBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _dlcFinishService = collectionService.dlcFinishService,
        super(
          service: collectionService.dlcService,
        );

  final DLCFinishService _dlcFinishService;

  @override
  Future<DLCDTO> getAdditionalFields(DLCDTO item) async {
    final DateTime? firstFinish =
        await _dlcFinishService.getFirstFinish(itemId);

    return _populateDlc(item, firstFinish);
  }

  @override
  DLCDTO addAdditionalFields(DLCDTO item, DLCDTO previousItem) {
    return _populateDlc(item, previousItem.firstFinish);
  }

  DLCDTO _populateDlc(DLCDTO item, DateTime? firstFinish) {
    item.firstFinish = firstFinish;

    return item;
  }
}
