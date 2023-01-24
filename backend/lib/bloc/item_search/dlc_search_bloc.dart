import 'package:game_collection_client/api.dart' show DLCDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, DLCService;

import 'item_search.dart';

class DLCSearchBloc extends ItemSearchBloc<DLCDTO, DLCService> {
  DLCSearchBloc({
    required GameCollectionService collectionService,
  }) : super(service: collectionService.dlcService);
}
