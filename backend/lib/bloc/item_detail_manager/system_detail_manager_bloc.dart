import 'package:backend/entity/entity.dart' show SystemEntity, SystemID;
import 'package:backend/model/model.dart' show System;
import 'package:backend/mapper/mapper.dart' show SystemMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import 'item_detail_manager.dart';


class SystemDetailManagerBloc extends ItemDetailManagerBloc<System, SystemEntity, SystemID, SystemRepository> {
  SystemDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(id: SystemID(itemId), repository: collectionRepository.systemRepository);

  @override
  Future<System> updateFuture(UpdateItemField<System> event) {

    final SystemEntity entity = SystemMapper.modelToEntity(event.item);
    final SystemEntity updatedEntity = SystemMapper.modelToEntity(event.updatedItem);
    final Future<SystemEntity> entityFuture = repository.update(entity, updatedEntity);
    return SystemMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<System> addImage(AddItemImage<System> event) {

    final Future<SystemEntity> entityFuture = repository.uploadSystemIcon(id, event.imagePath, event.oldImageName);
    return SystemMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<System> updateImageName(UpdateItemImageName<System> event) {

    final Future<SystemEntity> entityFuture = repository.renameSystemIcon(id, event.oldImageName, event.newImageName);
    return SystemMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<System> deleteImage(DeleteItemImage<System> event) {

    final Future<SystemEntity> entityFuture = repository.deleteSystemIcon(id, event.imageName);
    return SystemMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }
}