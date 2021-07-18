import 'package:backend/model/model.dart' show Item, Store, Purchase;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import 'item_relation_manager.dart';


class StoreRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<Store, W> {
  StoreRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.storeRepository = collectionRepository.storeRepository,
    super(itemId: itemId);

  final StoreRepository storeRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return storeRepository.relateStorePurchase(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return storeRepository.unrelateStorePurchase(otherId);
    }

    return super.deleteRelationFuture(event);

  }
}