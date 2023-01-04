import 'package:game_collection_client/api.dart' show GameDTO, NewGameDTO;

import 'package:backend/service/service.dart'
    show GameCollectionService, GameService;

import 'item_detail_manager.dart';

class GameDetailManagerBloc
    extends ItemWithImageDetailManagerBloc<GameDTO, NewGameDTO, GameService> {
  GameDetailManagerBloc({
    required int itemId,
    required GameCollectionService collectionService,
  }) : super(
          itemId: itemId,
          service: collectionService.gameService,
        );
}
