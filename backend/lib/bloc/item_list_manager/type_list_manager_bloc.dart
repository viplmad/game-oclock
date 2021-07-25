import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeID;
import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import 'item_list_manager.dart';


class TypeListManagerBloc extends ItemListManagerBloc<PurchaseType, PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeRepository> {
  TypeListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseTypeRepository);

  @override
  Future<PurchaseType> createFuture(AddItem<PurchaseType> event) {

    final PurchaseTypeEntity entity = PurchaseTypeMapper.modelToEntity(event.item);
    final Future<PurchaseTypeEntity> entityFuture = repository.create(entity);
    return PurchaseTypeMapper.futureEntityToModel(entityFuture);

  }

  @override
  Future<Object?> deleteFuture(DeleteItem<PurchaseType> event) {

    final PurchaseTypeEntity entity = PurchaseTypeMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());

  }
}