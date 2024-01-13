import 'package:game_oclock_client/api.dart' show PlatformDTO, NewPlatformDTO;

import 'package:logic/service/service.dart'
    show PlatformService, GameOClockService;

import 'item_list_manager.dart';

class PlatformListManagerBloc
    extends ItemListManagerBloc<PlatformDTO, NewPlatformDTO, PlatformService> {
  PlatformListManagerBloc({
    required GameOClockService collectionService,
  }) : super(service: collectionService.platformService);
}
