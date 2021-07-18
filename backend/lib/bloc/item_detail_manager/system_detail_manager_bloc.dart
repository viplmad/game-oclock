import 'package:backend/model/model.dart' show System;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import 'item_detail_manager.dart';


class SystemDetailManagerBloc extends ItemDetailManagerBloc<System, SystemRepository> {
  SystemDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(itemId: itemId, repository: collectionRepository.systemRepository);

  @override
  Future<System?> updateFuture(UpdateItemField<System> event) {

    return repository.updateSystem(event.item, event.updatedItem);

  }

  @override
  Future<System?> addImage(AddItemImage<System> event) {

    return repository.uploadSystemIcon(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<System?> updateImageName(UpdateItemImageName<System> event) {

    return repository.renameSystemIcon(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<System?> deleteImage(DeleteItemImage<System> event) {

    return repository.deleteSystemIcon(itemId, event.imageName);

  }
}