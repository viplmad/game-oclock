import 'package:backend/model/model.dart' show Item, Tag, Game;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, GameRepository;

import 'item_relation_manager.dart';


class TagRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<Tag, W> {
  TagRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.gameRepository = collectionRepository.gameRepository,
    super(itemId: itemId);

  final GameRepository gameRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return gameRepository.relateGameTag(otherId, itemId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return gameRepository.unrelateGameTag(otherId, itemId);
    }

    return super.deleteRelationFuture(event);

  }
}