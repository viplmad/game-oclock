import 'package:game_collection_client/api.dart'
    show PlatformDTO, NewPlatformDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, PlatformService;

import 'item_detail_manager.dart';

class PlatformDetailManagerBloc extends ItemWithImageDetailManagerBloc<
    PlatformDTO, NewPlatformDTO, PlatformService> {
  PlatformDetailManagerBloc({
    required int itemId,
    required GameCollectionService collectionService,
  }) : super(
          itemId: itemId,
          service: collectionService.platformService,
        );
}
