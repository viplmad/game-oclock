import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class SystemDetailManagerBloc extends ItemDetailManagerBloc<System> {

  SystemDetailManagerBloc({
    @required int itemId,
    ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<System> updateFuture(UpdateItemField<System> event) {

    return iCollectionRepository.updateSystem(itemId, event.field, event.value);

  }

  @override
  Future<System> addImage(AddItemImage<System> event) {

    return iCollectionRepository.uploadSystemIcon(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<System> updateImageName(UpdateItemImageName<System> event) {

    return iCollectionRepository.renameSystemIcon(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<System> deleteImage(DeleteItemImage<System> event) {

    return iCollectionRepository.deleteSystemIcon(itemId, event.imageName);

  }

}