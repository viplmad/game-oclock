import 'package:backend/model/model.dart' show Store;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import 'item_detail_manager.dart';


class StoreDetailManagerBloc extends ItemDetailManagerBloc<Store, StoreRepository> {
  StoreDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(itemId: itemId, repository: collectionRepository.storeRepository);

  @override
  Future<Store?> addImage(AddItemImage<Store> event) {

    return repository.uploadStoreIcon(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<Store?> updateImageName(UpdateItemImageName<Store> event) {

    return repository.renameStoreIcon(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<Store?> deleteImage(DeleteItemImage<Store> event) {

    return repository.deleteStoreIcon(itemId, event.imageName);

  }
}