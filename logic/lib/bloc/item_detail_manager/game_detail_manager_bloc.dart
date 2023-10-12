import 'package:game_collection_client/api.dart' show GameDTO, NewGameDTO;

import 'package:logic/service/service.dart' show GameOClockService, GameService;

import 'item_detail_manager.dart';

class GameDetailManagerBloc
    extends ItemWithImageDetailManagerBloc<GameDTO, NewGameDTO, GameService> {
  GameDetailManagerBloc({
    required super.itemId,
    required GameOClockService collectionService,
  }) : super(
          service: collectionService.gameService,
        );
}
