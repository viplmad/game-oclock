import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_detail_manager.dart';


class SystemDetailManagerBloc extends ItemDetailManagerBloc<System, SystemUpdateProperties> {
  SystemDetailManagerBloc({
    required int itemId,
    required CollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<System?> updateFuture(UpdateItemField<System, SystemUpdateProperties> event) {

    return iCollectionRepository.updateSystem(event.item, event.updatedItem, event.updateProperties);

  }

  @override
  Future<System?> addImage(AddItemImage<System> event) {

    return iCollectionRepository.uploadSystemIcon(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<System?> updateImageName(UpdateItemImageName<System> event) {

    return iCollectionRepository.renameSystemIcon(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<System?> deleteImage(DeleteItemImage<System> event) {

    return iCollectionRepository.deleteSystemIcon(itemId, event.imageName);

  }
}