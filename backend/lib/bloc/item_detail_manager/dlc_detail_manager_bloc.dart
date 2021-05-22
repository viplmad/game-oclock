import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_detail_manager.dart';


class DLCDetailManagerBloc extends ItemDetailManagerBloc<DLC, DLCUpdateProperties> {
  DLCDetailManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<DLC?> updateFuture(UpdateItemField<DLC, DLCUpdateProperties> event) {

    return iCollectionRepository.updateDLC(event.item, event.updatedItem, event.updateProperties);

  }

  @override
  Future<DLC?> addImage(AddItemImage<DLC> event) {

    return iCollectionRepository.uploadDLCCover(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<DLC?> updateImageName(UpdateItemImageName<DLC> event) {

    return iCollectionRepository.renameDLCCover(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<DLC?> deleteImage(DeleteItemImage<DLC> event) {

    return iCollectionRepository.deleteDLCCover(itemId, event.imageName);

  }
}