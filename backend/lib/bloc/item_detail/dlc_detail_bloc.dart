import 'package:game_collection_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:backend/model/model.dart' show DLCDetailed;
import 'package:backend/service/service.dart'
    show DLCFinishService, DLCService, GameCollectionService;

import 'item_detail.dart';

class DLCDetailBloc extends ItemDetailBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCDetailBloc({
    required int itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : dlcFinishService = collectionService.dlcFinishService,
        super(
          itemId: itemId,
          service: collectionService.dlcService,
        );

  final DLCFinishService dlcFinishService;

  @override
  Future<DLCDTO> get() async {
    final DLCDTO dlc = await super.get();
    final DateTime? firstFinish = await dlcFinishService.getFirstFinish(itemId);

    return DLCDetailed.withDTO(dlc, firstFinish);
  }
}
