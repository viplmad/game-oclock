import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class PlatformDetailManagerBloc extends ItemDetailManagerBloc<Platform> {

  PlatformDetailManagerBloc({
    @required int itemId,
    ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<Platform> updateFuture(UpdateItemField<Platform> event) {

    return iCollectionRepository.updatePlatform(itemId, event.field, event.value);

  }

  @override
  Future<Platform> addImage(AddItemImage<Platform> event) {

    return iCollectionRepository.uploadPlatformIcon(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<Platform> updateImageName(UpdateItemImageName<Platform> event) {

    return iCollectionRepository.renamePlatformIcon(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<Platform> deleteImage(DeleteItemImage<Platform> event) {

    return iCollectionRepository.deletePlatformIcon(itemId, event.imageName);

  }

}