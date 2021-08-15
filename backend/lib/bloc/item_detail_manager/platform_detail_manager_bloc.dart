import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformID;
import 'package:backend/model/model.dart' show Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_detail_manager.dart';


class PlatformDetailManagerBloc extends ItemDetailManagerBloc<Platform, PlatformEntity, PlatformID, PlatformRepository> {
  PlatformDetailManagerBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
  }) : super(id: PlatformID(itemId), repository: collectionRepository.platformRepository);

  @override
  Future<Platform> updateFuture(UpdateItemField<Platform> event) {

    final PlatformEntity entity = PlatformMapper.modelToEntity(event.item);
    final PlatformEntity updatedEntity = PlatformMapper.modelToEntity(event.updatedItem);
    final Future<PlatformEntity> entityFuture = repository.update(entity, updatedEntity);
    return PlatformMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<Platform> addImage(AddItemImage<Platform> event) {

    final Future<PlatformEntity> entityFuture = repository.uploadIcon(id, event.imagePath, event.oldImageName);
    return PlatformMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<Platform> updateImageName(UpdateItemImageName<Platform> event) {

    final Future<PlatformEntity> entityFuture = repository.renameIcon(id, event.oldImageName, event.newImageName);
    return PlatformMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<Platform> deleteImage(DeleteItemImage<Platform> event) {

    final Future<PlatformEntity> entityFuture = repository.deleteIcon(id, event.imageName);
    return PlatformMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }
}