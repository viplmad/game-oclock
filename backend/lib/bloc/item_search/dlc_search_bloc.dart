import 'package:game_collection_client/api.dart' show DLCDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, DLCService;
import 'package:backend/model/model.dart' show DLCView;

import 'item_search.dart';

class DLCSearchBloc extends ItemSearchBloc<DLCDTO, DLCService> {
  DLCSearchBloc({
    required GameCollectionService collectionService,
  }) : super(
          service: collectionService.dlcService,
          initialViewIndex: DLCView.lastUpdated.index,
        );
}
