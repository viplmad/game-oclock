import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class DLCDetailManagerBloc extends ItemDetailManagerBloc<DLC> {
  DLCDetailManagerBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<DLC> updateFuture(UpdateItemField<DLC> event) {

    return iCollectionRepository.updateDLC(itemId, event.field, event.value);

  }

  @override
  Future<DLC> addImage(AddItemImage<DLC> event) {

    return iCollectionRepository.uploadDLCCover(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<DLC> updateImageName(UpdateItemImageName<DLC> event) {

    return iCollectionRepository.renameDLCCover(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<DLC> deleteImage(DeleteItemImage<DLC> event) {

    return iCollectionRepository.deleteDLCCover(itemId, event.imageName);

  }
}