import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class TagRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Tag, W> {
  TagRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.relateGameTag(otherId, itemId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.unrelateGameTag(otherId, itemId);
    }

    return super.deleteRelationFuture(event);

  }
}