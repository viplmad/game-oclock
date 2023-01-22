import 'package:game_collection_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:backend/service/service.dart'
    show DLCService, GameCollectionService;

import 'item_list.dart';

class DLCListBloc extends ItemListBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCListBloc({
    required GameCollectionService collectionService,
    required super.managerBloc,
  }) : super(service: collectionService.dlcService);
}
