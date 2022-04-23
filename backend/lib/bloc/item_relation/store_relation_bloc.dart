import 'package:backend/entity/entity.dart' show PurchaseEntity, StoreID;
import 'package:backend/model/model.dart' show Item, Store, Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, PurchaseRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';

class StoreRelationBloc<W extends Item>
    extends ItemRelationBloc<Store, StoreID, W> {
  StoreRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required StoreRelationManagerBloc<W> managerBloc,
  })  : purchaseRepository = collectionRepository.purchaseRepository,
        super(
          id: StoreID(itemId),
          collectionRepository: collectionRepository,
          managerBloc: managerBloc,
        );

  final PurchaseRepository purchaseRepository;

  @override
  Future<List<W>> getRelationItems() {
    switch (W) {
      case Purchase:
        final Future<List<PurchaseEntity>> entityListFuture =
            purchaseRepository.findAllFromStore(id);
        return PurchaseMapper.futureEntityListToModelList(entityListFuture)
            as Future<List<W>>;
    }

    return super.getRelationItems();
  }
}
