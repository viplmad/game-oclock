import 'package:backend/entity/entity.dart' show PurchaseEntity, PurchaseID;
import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import 'item_list_manager.dart';


class PurchaseListManagerBloc extends ItemListManagerBloc<Purchase, PurchaseEntity, PurchaseID, PurchaseRepository> {
  PurchaseListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseRepository);

  @override
  Future<Purchase> createFuture(AddItem<Purchase> event) {

    final PurchaseEntity entity = PurchaseMapper.modelToEntity(event.item);
    final Future<PurchaseEntity> entityFuture = repository.create(entity);
    return PurchaseMapper.futureEntityToModel(entityFuture);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Purchase> event) {

    final PurchaseEntity entity = PurchaseMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());

  }
}