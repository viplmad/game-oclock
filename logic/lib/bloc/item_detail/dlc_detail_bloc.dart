import 'package:game_oclock_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:logic/service/service.dart' show DLCService, GameOClockService;

import 'item_detail.dart';

class DLCDetailBloc extends ItemDetailBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCDetailBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  }) : super(
          service: collectionService.dlcService,
        );
}
