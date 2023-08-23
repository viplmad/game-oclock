import 'package:game_collection_client/api.dart' show GameDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameService;

import 'item_relation.dart';

class TagGameRelationBloc extends ItemRelationBloc<GameDTO, GameDTO> {
  TagGameRelationBloc({
    required super.itemId,
    required GameCollectionService collectionService,
    required super.managerBloc,
  })  : _gameService = collectionService.gameService,
        super();

  final GameService _gameService;

  @override
  Future<List<GameDTO>> getRelationItems() {
    return _gameService.getTaggedGames(itemId);
  }
}
