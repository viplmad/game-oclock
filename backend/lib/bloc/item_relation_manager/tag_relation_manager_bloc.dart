import 'package:backend/entity/entity.dart' show GameEntity, GameTagID;
import 'package:backend/model/model.dart' show Item, Tag, Game;
import 'package:backend/mapper/mapper.dart' show GameMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import 'item_relation_manager.dart';


class TagRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<Tag, GameTagID, W> {
  TagRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    super(id: GameTagID(itemId));

  final GameRepository gameRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Game:
        final GameEntity otherEntity = GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.relateGameTag(otherEntity.createId(), id);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Game:
        final GameEntity otherEntity = GameMapper.modelToEntity(otherItem as Game);
        return gameRepository.unrelateGameTag(otherEntity.createId(), id);
    }

    return super.deleteRelationFuture(event);

  }
}