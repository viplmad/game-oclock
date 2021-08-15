import 'package:backend/entity/entity.dart' show PlatformEntity, PlatformID;
import 'package:backend/model/model.dart' show Platform;
import 'package:backend/mapper/mapper.dart' show PlatformMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PlatformRepository;

import 'item_list_manager.dart';


class PlatformListManagerBloc extends ItemListManagerBloc<Platform, PlatformEntity, PlatformID, PlatformRepository> {
  PlatformListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.platformRepository);

  @override
  Future<Platform> createFuture(AddItem<Platform> event) {

    final PlatformEntity entity = PlatformMapper.modelToEntity(event.item);
    final Future<PlatformEntity> entityFuture = repository.create(entity);
    return PlatformMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<Object?> deleteFuture(DeleteItem<Platform> event) {

    final PlatformEntity entity = PlatformMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());

  }
}