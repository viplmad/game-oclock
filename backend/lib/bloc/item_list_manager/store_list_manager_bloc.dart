import 'package:backend/entity/entity.dart' show StoreEntity, StoreID;
import 'package:backend/model/model.dart' show Store;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import 'item_list_manager.dart';


class StoreListManagerBloc extends ItemListManagerBloc<Store, StoreEntity, StoreID, StoreRepository> {
  StoreListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.storeRepository);

  @override
  Future<Store> createFuture(AddItem<Store> event) {

    final StoreEntity entity = StoreMapper.modelToEntity(event.item);
    final Future<StoreEntity> entityFuture = repository.create(entity);
    return StoreMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Store> event) {

    final StoreEntity entity = StoreMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());

  }
}