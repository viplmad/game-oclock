import 'package:game_collection_client/api.dart' show GameDTO, NewGameDTO;

import 'package:logic/service/service.dart'
    show GameService, GameCollectionService;

import 'item_list_manager.dart';

class GameListManagerBloc
    extends ItemListManagerBloc<GameDTO, NewGameDTO, GameService> {
  GameListManagerBloc({
    required GameCollectionService collectionService,
  }) : super(service: collectionService.gameService);
}
