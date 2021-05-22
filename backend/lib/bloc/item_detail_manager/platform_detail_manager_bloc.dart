import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class PlatformDetailManagerBloc extends ItemDetailManagerBloc<Platform, PlatformUpdateProperties> {
  PlatformDetailManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Platform?> updateFuture(UpdateItemField<Platform, PlatformUpdateProperties> event) {

    return iCollectionRepository.updatePlatform(event.item, event.updatedItem, event.updateProperties);

  }

  @override
  Future<Platform?> addImage(AddItemImage<Platform> event) {

    return iCollectionRepository.uploadPlatformIcon(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<Platform?> updateImageName(UpdateItemImageName<Platform> event) {

    return iCollectionRepository.renamePlatformIcon(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<Platform?> deleteImage(DeleteItemImage<Platform> event) {

    return iCollectionRepository.deletePlatformIcon(itemId, event.imageName);

  }
}