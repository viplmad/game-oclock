import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class SystemDetailManagerBloc extends ItemDetailManagerBloc<System> {

  SystemDetailManagerBloc({
    @required int itemID,
    ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Future<System> updateFuture(UpdateItemField<System> event) {

    return iCollectionRepository.updateSystem(itemID, event.field, event.value);

  }

  @override
  Future<System> addImage(AddItemImage<System> event) {

    return iCollectionRepository.uploadSystemIcon(itemID, event.imagePath, event.oldImageName);

  }

  @override
  Future<System> updateImageName(UpdateItemImageName<System> event) {

    return iCollectionRepository.renameSystemIcon(itemID, event.oldImageName, event.newImageName);

  }

  @override
  Future<System> deleteImage(DeleteItemImage<System> event) {

    return iCollectionRepository.deleteSystemIcon(itemID, event.imageName);

  }

}