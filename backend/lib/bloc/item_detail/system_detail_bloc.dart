import 'package:backend/entity/entity.dart' show SystemEntity, SystemID;
import 'package:backend/model/model.dart' show System;
import 'package:backend/mapper/mapper.dart' show SystemMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class SystemDetailBloc extends ItemDetailBloc<System, SystemEntity, SystemID, SystemRepository> {
  SystemDetailBloc({
    required int itemId,
    required GameCollectionRepository collectionRepository,
    required SystemDetailManagerBloc managerBloc,
  }) : super(id: SystemID(itemId), repository: collectionRepository.systemRepository, managerBloc: managerBloc);

  @override
  Future<System> getReadFuture() {

    final Future<SystemEntity> entityFuture = repository.findById(id);
    return SystemMapper.futureEntityToModel(entityFuture, repository.getImageURI);

  }
}