import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeID;
import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import 'item_detail_manager.dart';


class PurchaseTypeDetailManagerBloc extends ItemDetailManagerBloc<PurchaseType, PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeRepository> {
  PurchaseTypeDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(id: PurchaseTypeID(itemId), repository: collectionRepository.purchaseTypeRepository);

  @override
  Future<PurchaseType> updateFuture(UpdateItemField<PurchaseType> event) {

    final PurchaseTypeEntity entity = PurchaseTypeMapper.modelToEntity(event.item);
    final PurchaseTypeEntity updatedEntity = PurchaseTypeMapper.modelToEntity(event.updatedItem);
    final Future<PurchaseTypeEntity> entityFuture = repository.update(entity, updatedEntity);
    return PurchaseTypeMapper.futureEntityToModel(entityFuture);

  }
}