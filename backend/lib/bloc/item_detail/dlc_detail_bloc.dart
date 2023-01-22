import 'package:game_collection_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:backend/service/service.dart'
    show DLCFinishService, DLCService, GameCollectionService;

import 'item_detail.dart';

class DLCDetailBloc extends ItemDetailBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCDetailBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : dlcFinishService = collectionService.dlcFinishService,
        super(
          service: collectionService.dlcService,
        );

  final DLCFinishService dlcFinishService;

  @override
  Future<DLCDTO> getAdditionalFields(DLCDTO item) async {
    final DateTime? firstFinish = await dlcFinishService.getFirstFinish(itemId);

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
