import 'package:backend/entity/entity.dart' show SystemEntity, SystemID;
import 'package:backend/model/model.dart' show System;
import 'package:backend/mapper/mapper.dart' show SystemMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, SystemRepository;

import 'item_list_manager.dart';

class SystemListManagerBloc extends ItemListManagerBloc<System, SystemEntity,
    SystemID, SystemRepository> {
  SystemListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.systemRepository);

  @override
  Future<System> createFuture(AddItem<System> event) {
    final SystemEntity entity = SystemMapper.modelToEntity(event.item);
    final Future<SystemEntity> entityFuture = repository.create(entity);
    return SystemMapper.futureEntityToModel(
      entityFuture,
      repository.getImageURI,
    );
  }

  @override
  Future<Object?> deleteFuture(DeleteItem<System> event) {
    final SystemEntity entity = SystemMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());
  }
}
