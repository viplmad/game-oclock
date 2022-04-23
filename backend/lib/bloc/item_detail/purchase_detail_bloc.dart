import 'package:backend/entity/entity.dart' show PurchaseEntity, PurchaseID;
import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, PurchaseRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';

class PurchaseDetailBloc extends ItemDetailBloc<Purchase, PurchaseEntity,
    PurchaseID, PurchaseRepository> {
  PurchaseDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required PurchaseDetailManagerBloc managerBloc,
  }) : super(
          id: PurchaseID(itemId),
          repository: collectionRepository.purchaseRepository,
          managerBloc: managerBloc,
        );

  @override
  Future<Purchase> get() {
    final Future<PurchaseEntity> entityFuture = repository.findById(id);
    return PurchaseMapper.futureEntityToModel(entityFuture);
  }
}
