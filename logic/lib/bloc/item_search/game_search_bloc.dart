import 'package:game_oclock_client/api.dart' show GameDTO;

import 'package:logic/service/service.dart' show GameOClockService, GameService;

import 'item_search.dart';

class GameSearchBloc extends ItemSearchBloc<GameDTO, GameService> {
  GameSearchBloc({
    required GameOClockService collectionService,
  }) : super(service: collectionService.gameService);
}
