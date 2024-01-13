import 'package:game_oclock_client/api.dart' show GameDTO, NewGameDTO;

import 'package:logic/service/service.dart' show GameService, GameOClockService;

import 'item_list_manager.dart';

class GameListManagerBloc
    extends ItemListManagerBloc<GameDTO, NewGameDTO, GameService> {
  GameListManagerBloc({
    required GameOClockService collectionService,
  }) : super(service: collectionService.gameService);
}
