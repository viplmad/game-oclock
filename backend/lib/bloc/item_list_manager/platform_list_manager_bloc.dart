import 'package:game_collection_client/api.dart'
    show PlatformDTO, NewPlatformDTO;

import 'package:backend/service/service.dart'
    show PlatformService, GameCollectionService;

import 'item_list_manager.dart';

class PlatformListManagerBloc
    extends ItemListManagerBloc<PlatformDTO, NewPlatformDTO, PlatformService> {
  PlatformListManagerBloc({
    required GameCollectionService collectionService,
  }) : super(service: collectionService.platformService);
}
