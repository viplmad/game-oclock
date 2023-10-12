import 'package:game_collection_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:logic/service/service.dart' show DLCService, GameOClockService;

import 'item_list_manager.dart';

class DLCListManagerBloc
    extends ItemListManagerBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCListManagerBloc({
    required GameOClockService collectionService,
  }) : super(service: collectionService.dlcService);
}
