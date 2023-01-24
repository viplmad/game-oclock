import 'package:game_collection_client/api.dart' show PlatformDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, PlatformService;

import 'item_search.dart';

class PlatformSearchBloc extends ItemSearchBloc<PlatformDTO, PlatformService> {
  PlatformSearchBloc({
    required GameCollectionService collectionService,
  }) : super(service: collectionService.platformService);
}
