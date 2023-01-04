import 'package:game_collection_client/api.dart' show PlatformDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, PlatformService;
import 'package:backend/model/model.dart' show PlatformView;

import 'item_search.dart';

class PlatformSearchBloc extends ItemSearchBloc<PlatformDTO, PlatformService> {
  PlatformSearchBloc({
    required GameCollectionService collectionService,
  }) : super(
          service: collectionService.platformService,
          initialViewIndex: PlatformView.lastUpdated.index,
        );
}
