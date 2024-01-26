import 'package:game_oclock_client/api.dart' show GameDTO, NewGameDTO;

import 'package:logic/service/service.dart' show GameOClockService, GameService;

import 'item_detail.dart';

class GameDetailBloc extends ItemDetailBloc<GameDTO, NewGameDTO, GameService> {
  GameDetailBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  }) : super(
          service: collectionService.gameService,
        );
}
