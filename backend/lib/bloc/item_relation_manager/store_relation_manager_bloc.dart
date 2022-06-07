import 'package:backend/entity/entity.dart' show PurchaseEntity, StoreID;
import 'package:backend/model/model.dart' show Item, Store, Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart'
    show StoreRepository;

import 'item_relation_manager.dart';

class StoreRelationManagerBloc<W extends Item>
    extends ItemRelationManagerBloc<Store, StoreID, W> {
  StoreRelationManagerBloc({
    required int itemId,
    required super.collectionRepository,
  })  : storeRepository = collectionRepository.storeRepository,
        super(id: StoreID(itemId));

  final StoreRepository storeRepository;

  @override
  Future<Object?> addRelation(AddItemRelation<W> event) {
    final W otherItem = event.otherItem;

    switch (W) {
      case Purchase:
        final PurchaseEntity otherEntity =
            PurchaseMapper.modelToEntity(otherItem as Purchase);
        return storeRepository.relateStorePurchase(id, otherEntity.createId());
    }

    return super.addRelation(event);
  }

  @override
  Future<Object?> deleteRelation(DeleteItemRelation<W> event) {
    final W otherItem = event.otherItem;

    switch (W) {
      case Purchase:
        final PurchaseEntity otherEntity =
            PurchaseMapper.modelToEntity(otherItem as Purchase);
        return storeRepository.unrelateStorePurchase(otherEntity.createId());
    }

    return super.deleteRelation(event);
  }
}
