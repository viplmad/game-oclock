import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class TypeRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<PurchaseType, W> {
  TypeRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return iCollectionRepository.relatePurchaseType(otherId, itemId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return iCollectionRepository.unrelatePurchaseType(otherId, itemId);
    }

    return super.deleteRelationFuture(event);

  }
}