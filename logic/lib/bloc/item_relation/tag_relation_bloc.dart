import 'package:game_oclock_client/api.dart' show GameDTO;

import 'package:logic/service/service.dart' show GameOClockService, GameService;

import 'item_relation.dart';

class TagGameRelationBloc extends ItemRelationBloc<GameDTO, GameDTO> {
  TagGameRelationBloc({
    required super.itemId,
    required GameOClockService collectionService,
    required super.managerBloc,
  })  : _gameService = collectionService.gameService,
        super();

  final GameService _gameService;

  @override
  Future<List<GameDTO>> getRelationItems() {
    return _gameService.getTaggedGames(itemId);
  }
}
