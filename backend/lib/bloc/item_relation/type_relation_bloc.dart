import 'package:backend/entity/entity.dart' show PurchaseEntity, PurchaseTypeID;
import 'package:backend/model/model.dart' show Item, PurchaseType, Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class TypeRelationBloc<W extends Item> extends ItemRelationBloc<PurchaseType, PurchaseTypeID, W> {
  TypeRelationBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required TypeRelationManagerBloc<W> managerBloc,
  }) :
    this.purchaseRepository = collectionRepository.purchaseRepository,
    super(id: PurchaseTypeID(itemId), managerBloc: managerBloc);

  final PurchaseRepository purchaseRepository;

  @override
  Future<List<W>> getRelationStream() {

    switch(W) {
      case Purchase:
        final Future<List<PurchaseEntity>> entityListFuture = purchaseRepository.findAllFromPurchaseType(id);
        return PurchaseMapper.futureEntityListToModelList(entityListFuture) as Future<List<W>>;
    }

    return super.getRelationStream();

  }
}