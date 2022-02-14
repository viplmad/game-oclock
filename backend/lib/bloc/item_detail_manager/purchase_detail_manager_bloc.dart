import 'package:backend/entity/entity.dart' show PurchaseEntity, PurchaseID;
import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, PurchaseRepository;

import 'item_detail_manager.dart';

class PurchaseDetailManagerBloc extends ItemDetailManagerBloc<Purchase,
    PurchaseEntity, PurchaseID, PurchaseRepository> {
  PurchaseDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(
          id: PurchaseID(itemId),
          repository: collectionRepository.purchaseRepository,
        );

  @override
  Future<Purchase> updateFuture(UpdateItemField<Purchase> event) {
    final PurchaseEntity entity = PurchaseMapper.modelToEntity(event.item);
    final PurchaseEntity updatedEntity =
        PurchaseMapper.modelToEntity(event.updatedItem);
    final Future<PurchaseEntity> entityFuture =
        repository.update(entity, updatedEntity);
    return PurchaseMapper.futureEntityToModel(entityFuture);
  }
}
