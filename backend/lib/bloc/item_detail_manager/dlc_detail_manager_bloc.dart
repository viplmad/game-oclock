import 'package:game_collection_client/api.dart' show DLCDTO, NewDLCDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, DLCService;

import 'item_detail_manager.dart';

class DLCDetailManagerBloc
    extends ItemWithImageDetailManagerBloc<DLCDTO, NewDLCDTO, DLCService> {
  DLCDetailManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  }) : super(
          service: collectionService.dlcService,
        );
}
