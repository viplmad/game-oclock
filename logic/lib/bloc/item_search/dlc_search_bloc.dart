import 'package:game_oclock_client/api.dart' show DLCDTO;

import 'package:logic/service/service.dart' show GameOClockService, DLCService;

import 'item_search.dart';

class DLCSearchBloc extends ItemSearchBloc<DLCDTO, DLCService> {
  DLCSearchBloc({
    required GameOClockService collectionService,
  }) : super(service: collectionService.dlcService);
}
