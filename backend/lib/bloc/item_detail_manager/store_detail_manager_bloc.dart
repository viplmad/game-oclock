import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class StoreDetailManagerBloc extends ItemDetailManagerBloc<Store, StoreUpdateProperties> {
  StoreDetailManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Store?> updateFuture(UpdateItemField<Store, StoreUpdateProperties> event) {

    return iCollectionRepository.updateStore(event.item, event.updatedItem, event.updateProperties);

  }

  @override
  Future<Store?> addImage(AddItemImage<Store> event) {

    return iCollectionRepository.uploadStoreIcon(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<Store?> updateImageName(UpdateItemImageName<Store> event) {

    return iCollectionRepository.renameStoreIcon(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<Store?> deleteImage(DeleteItemImage<Store> event) {

    return iCollectionRepository.deleteStoreIcon(itemId, event.imageName);

  }
}