import 'package:backend/model/model.dart' show DLC;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import 'item_detail_manager.dart';


class DLCDetailManagerBloc extends ItemDetailManagerBloc<DLC, DLCRepository> {
  DLCDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(itemId: itemId, repository: collectionRepository.dlcRepository);

  @override
  Future<DLC?> addImage(AddItemImage<DLC> event) {

    return repository.uploadDLCCover(itemId, event.imagePath, event.oldImageName);

  }

  @override
  Future<DLC?> updateImageName(UpdateItemImageName<DLC> event) {

    return repository.renameDLCCover(itemId, event.oldImageName, event.newImageName);

  }

  @override
  Future<DLC?> deleteImage(DeleteItemImage<DLC> event) {

    return repository.deleteDLCCover(itemId, event.imageName);

  }
}