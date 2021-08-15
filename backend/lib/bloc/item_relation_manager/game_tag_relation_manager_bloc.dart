import 'package:backend/entity/entity.dart' show GameEntity, GameTagID;
import 'package:backend/model/model.dart' show Item, GameTag, Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import 'item_relation_manager.dart';


class GameTagRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<GameTag, GameTagID, W> {
  GameTagRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    super(id: GameTagID(itemId), collectionRepository: collectionRepository);

  final GameRepository gameRepository;

  @override
  Future<Object?> addRelationFuture(AddItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Game:
        final GameEntity otherEntity = GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.relateGameTag(otherEntity.createId(), id);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<Object?> deleteRelationFuture(DeleteItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Game:
        final GameEntity otherEntity = GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.unrelateGameTag(otherEntity.createId(), id);
    }

    return super.deleteRelationFuture(event);

  }
}