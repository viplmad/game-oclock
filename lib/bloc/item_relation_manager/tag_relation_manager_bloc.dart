import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class TagRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Tag, W> {

  TagRelationManagerBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.relateGameTag(otherID, itemID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.id;

    switch(W) {
      case Game:
        return iCollectionRepository.deleteGameTag(otherID, itemID);
    }

    return super.deleteRelationFuture(event);

  }

}