import 'package:game_collection_client/api.dart' show GameDTO;

import 'package:logic/service/service.dart'
    show GameCollectionService, GameService;

import 'item_relation_manager.dart';

class TagGameRelationManagerBloc extends ItemRelationManagerBloc<GameDTO> {
  TagGameRelationManagerBloc({
    required super.itemId,
    required GameCollectionService collectionService,
  })  : _gameService = collectionService.gameService,
        super();

  final GameService _gameService;

  @override
  Future<void> addRelation(AddItemRelation<GameDTO> event) {
    return _gameService.tag(event.otherItem.id, itemId);
  }

  @override
  Future<void> deleteRelation(DeleteItemRelation<GameDTO> event) {
    return _gameService.untag(event.otherItem.id, itemId);
  }
}
