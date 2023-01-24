import 'package:game_collection_client/api.dart' show GameDTO, NewGameDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameService;

import 'item_detail_manager.dart';

class GameDetailManagerBloc
    extends ItemWithImageDetailManagerBloc<GameDTO, NewGameDTO, GameService> {
  GameDetailManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  }) : super(
          service: collectionService.gameService,
        );
}
