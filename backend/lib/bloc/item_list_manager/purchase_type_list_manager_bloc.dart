import 'package:backend/entity/entity.dart'
    show PurchaseTypeEntity, PurchaseTypeID;
import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, PurchaseTypeRepository;

import 'item_list_manager.dart';

class PurchaseTypeListManagerBloc extends ItemListManagerBloc<PurchaseType,
    PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeRepository> {
  PurchaseTypeListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseTypeRepository);

  @override
  Future<PurchaseType> create(AddItem<PurchaseType> event) {
    final PurchaseTypeEntity entity =
        PurchaseTypeMapper.modelToEntity(event.item);
    final Future<PurchaseTypeEntity> entityFuture = repository.create(entity);
    return PurchaseTypeMapper.futureEntityToModel(entityFuture);
  }

  @override
  Future<Object?> delete(DeleteItem<PurchaseType> event) {
    final PurchaseTypeEntity entity =
        PurchaseTypeMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());
  }
}
