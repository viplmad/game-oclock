import 'package:backend/entity/entity.dart' show GameEntity, GameTagID;
import 'package:backend/model/model.dart' show Item, GameTag, Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class TagRelationBloc<W extends Item> extends ItemRelationBloc<GameTag, GameTagID, W> {
  TagRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required TagRelationManagerBloc<W> managerBloc,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    super(id: GameTagID(itemId), managerBloc: managerBloc);

  final GameRepository gameRepository;

  @override
  Future<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        final Future<List<GameEntity>> entityListFuture = gameRepository.findAllFromGameTag(id);
        return GameMapper.futureEntityListToModelList(entityListFuture, gameRepository.getImageURI) as Future<List<W>>;
    }

    return super.getRelationStream();

  }
}