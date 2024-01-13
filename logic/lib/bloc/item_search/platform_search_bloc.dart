import 'package:game_oclock_client/api.dart' show PlatformDTO;

import 'package:logic/service/service.dart'
    show GameOClockService, PlatformService;

import 'item_search.dart';

class PlatformSearchBloc extends ItemSearchBloc<PlatformDTO, PlatformService> {
  PlatformSearchBloc({
    required GameOClockService collectionService,
  }) : super(service: collectionService.platformService);
}
