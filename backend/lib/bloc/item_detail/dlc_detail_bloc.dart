import 'package:backend/entity/entity.dart' show DLCEntity, DLCID;
import 'package:backend/model/model.dart' show DLC;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class DLCDetailBloc extends ItemDetailBloc<DLC, DLCEntity, DLCID, DLCRepository> {
  DLCDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required DLCDetailManagerBloc managerBloc,
  }) : super(id: DLCID(itemId), repository: collectionRepository.dlcRepository, managerBloc: managerBloc);

  @override
  Future<DLC> getReadFuture() {

    final Future<DLCEntity> entityFuture = repository.findById(id);
    return DLCMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }
}