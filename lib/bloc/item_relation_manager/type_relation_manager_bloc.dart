import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class TypeRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<PurchaseType, W> {

  TypeRelationManagerBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return iCollectionRepository.relatePurchaseType(otherId, itemId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return iCollectionRepository.deletePurchaseType(otherId, itemId);
    }

    return super.deleteRelationFuture(event);

  }

}