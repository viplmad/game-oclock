import 'package:game_collection_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:logic/service/service.dart' show GameOClockService, DLCService;

import 'item_detail_manager.dart';

class DLCDetailManagerBloc
    extends ItemWithImageDetailManagerBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCDetailManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  }) : super(
          service: collectionService.dlcService,
        );
}
