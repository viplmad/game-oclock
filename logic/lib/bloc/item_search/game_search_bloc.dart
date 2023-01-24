import 'package:game_collection_client/api.dart' show GameDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameService;

import 'item_search.dart';

class GameSearchBloc extends ItemSearchBloc<GameDTO, GameService> {
  GameSearchBloc({
    required GameCollectionService collectionService,
  }) : super(service: collectionService.gameService);
}
