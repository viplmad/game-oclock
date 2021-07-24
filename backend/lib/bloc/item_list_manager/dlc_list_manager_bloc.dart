import 'package:backend/entity/entity.dart' show DLCEntity, DLCID;
import 'package:backend/model/model.dart' show DLC;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import 'item_list_manager.dart';


class DLCListManagerBloc extends ItemListManagerBloc<DLC, DLCEntity, DLCID, DLCRepository> {
  DLCListManagerBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.dlcRepository);

  @override
  Future<DLC> createFuture(AddItem<DLC> event) {

    final DLCEntity entity = DLCMapper.modelToEntity(event.item);
    final Future<DLCEntity> entityFuture = repository.create(entity);
    return DLCMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<DLC> event) {

    final DLCEntity entity = DLCMapper.modelToEntity(event.item);
    return repository.deleteById(entity.createId());

  }
}