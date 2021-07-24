import 'package:backend/entity/entity.dart' show StoreEntity, StoreID;
import 'package:backend/model/model.dart' show Store;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import 'item_detail_manager.dart';


class StoreDetailManagerBloc extends ItemDetailManagerBloc<Store, StoreEntity, StoreID, StoreRepository> {
  StoreDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(id: StoreID(itemId), repository: collectionRepository.storeRepository);

  @override
  Future<Store> updateFuture(UpdateItemField<Store> event) {

    final StoreEntity entity = StoreMapper.modelToEntity(event.item);
    final StoreEntity updatedEntity = StoreMapper.modelToEntity(event.updatedItem);
    final Future<StoreEntity> entityFuture = repository.update(entity, updatedEntity);
    return StoreMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<Store> addImage(AddItemImage<Store> event) {

    final Future<StoreEntity> entityFuture = repository.uploadStoreIcon(id, event.imagePath, event.oldImageName);
    return StoreMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<Store> updateImageName(UpdateItemImageName<Store> event) {

    final Future<StoreEntity> entityFuture = repository.renameStoreIcon(id, event.oldImageName, event.newImageName);
    return StoreMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<Store> deleteImage(DeleteItemImage<Store> event) {

    final Future<StoreEntity> entityFuture = repository.deleteStoreIcon(id, event.imageName);
    return StoreMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }
}