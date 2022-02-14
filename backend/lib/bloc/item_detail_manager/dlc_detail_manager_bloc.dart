import 'package:backend/entity/entity.dart' show DLCEntity, DLCID;
import 'package:backend/model/model.dart' show DLC;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, DLCRepository;

import 'item_detail_manager.dart';

class DLCDetailManagerBloc
    extends ItemDetailManagerBloc<DLC, DLCEntity, DLCID, DLCRepository> {
  DLCDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(id: DLCID(itemId), repository: collectionRepository.dlcRepository);

  @override
  Future<DLC> updateFuture(UpdateItemField<DLC> event) {
    final DLCEntity entity = DLCMapper.modelToEntity(event.item);
    final DLCEntity updatedEntity = DLCMapper.modelToEntity(event.updatedItem);
    final Future<DLCEntity> entityFuture =
        repository.update(entity, updatedEntity);
    return DLCMapper.futureEntityToModel(entityFuture, repository.getImageURI);
  }

  @override
  Future<DLC> addImage(AddItemImage<DLC> event) async {
    final Future<DLCEntity> entityFuture =
        repository.uploadCover(id, event.imagePath, event.oldImageName);
    return DLCMapper.futureEntityToModel(entityFuture, repository.getImageURI);
  }

  @override
  Future<DLC> updateImageName(UpdateItemImageName<DLC> event) {
    final Future<DLCEntity> entityFuture =
        repository.renameCover(id, event.oldImageName, event.newImageName);
    return DLCMapper.futureEntityToModel(entityFuture, repository.getImageURI);
  }

  @override
  Future<DLC> deleteImage(DeleteItemImage<DLC> event) {
    final Future<DLCEntity> entityFuture =
        repository.deleteCover(id, event.imageName);
    return DLCMapper.futureEntityToModel(entityFuture, repository.getImageURI);
  }
}
