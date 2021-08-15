import 'package:backend/entity/entity.dart' show PurchaseEntity, PurchaseTypeID;
import 'package:backend/model/model.dart' show Item, PurchaseType, Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import 'item_relation_manager.dart';


class PurchaseTypeRelationManagerBloc<W extends Item> extends ItemRelationManagerBloc<PurchaseType, PurchaseTypeID, W> {
  PurchaseTypeRelationManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) :
    this.purchaseRepository = collectionRepository.purchaseRepository,
    super(id: PurchaseTypeID(itemId), collectionRepository: collectionRepository);

  final PurchaseRepository purchaseRepository;

  @override
  Future<Object?> addRelationFuture(AddItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Purchase:
        final PurchaseEntity otherEntity = PurchaseMapper.modelToEntity(otherItem as Purchase);
        return purchaseRepository.relatePurchaseType(otherEntity.createId(), id);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<Object?> deleteRelationFuture(DeleteItemRelation<W> event) {

    final W otherItem = event.otherItem;

    switch(W) {
      case Purchase:
        final PurchaseEntity otherEntity = PurchaseMapper.modelToEntity(otherItem as Purchase);
        return purchaseRepository.unrelatePurchaseType(otherEntity.createId(), id);
    }

    return super.deleteRelationFuture(event);

  }
}