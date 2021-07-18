import 'package:backend/model/model.dart' show Item, PurchaseType, Purchase;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import 'item_relation_manager.dart';


class TypeRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<PurchaseType, W> {
  TypeRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.purchaseRepository = collectionRepository.purchaseRepository,
    super(itemId: itemId);

  final PurchaseRepository purchaseRepository;

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return purchaseRepository.relatePurchaseType(otherId, itemId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    final int otherId = event.otherItem.id;

    switch(W) {
      case Purchase:
        return purchaseRepository.unrelatePurchaseType(otherId, itemId);
    }

    return super.deleteRelationFuture(event);

  }
}