import 'package:game_collection_client/api.dart'
    show PlatformDTO, NewPlatformDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, PlatformService;

import 'item_detail.dart';

class PlatformDetailBloc
    extends ItemDetailBloc<PlatformDTO, NewPlatformDTO, PlatformService> {
  PlatformDetailBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  }) : super(
          service: collectionService.platformService,
        );
}
