import 'package:game_collection_client/api.dart' show GameDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameService;

import 'item_relation.dart';

class TagGameRelationBloc extends ItemRelationBloc<GameDTO> {
  TagGameRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : gameService = collectionService.gameService,
        super();

  final GameService gameService;

  @override
  Future<List<GameDTO>> getRelationItems() {
    return gameService.getTaggedGames(itemId);
  }
}
