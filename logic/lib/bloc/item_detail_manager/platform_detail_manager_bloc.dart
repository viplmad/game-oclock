import 'package:game_oclock_client/api.dart' show PlatformDTO, NewPlatformDTO;

import 'package:logic/service/service.dart'
    show GameOClockService, PlatformService;

import 'item_detail_manager.dart';

class PlatformDetailManagerBloc extends ItemWithImageDetailManagerBloc<
    PlatformDTO, NewPlatformDTO, PlatformService> {
  PlatformDetailManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  }) : super(
          service: collectionService.platformService,
        );
}
