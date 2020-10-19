import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class StoreRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Store, W> {
  StoreRelationManagerBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return iCollectionRepository.relateStorePurchase(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return iCollectionRepository.deleteStorePurchase(otherId);
    }

    return super.deleteRelationFuture(event);

  }
}