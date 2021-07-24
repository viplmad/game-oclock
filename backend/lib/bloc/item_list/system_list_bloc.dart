import 'package:backend/entity/entity.dart' show SystemEntity, SystemID, SystemView;
import 'package:backend/model/model.dart' show System;
import 'package:backend/mapper/mapper.dart' show SystemMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class SystemListBloc extends ItemListBloc<System, SystemEntity, SystemID, SystemRepository> {
  SystemListBloc({
    required GameCollectionRepository collectionRepository,
    required SystemListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.systemRepository, managerBloc: managerBloc);

  @override
  Future<List<System>> getReadAllStream() {

    final Future<List<SystemEntity>> entityListFuture = repository.findAllSystemsWithView(SystemView.Main);
    return SystemMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<System>> getReadViewStream(UpdateView event) {

    final SystemView view = SystemView.values[event.viewIndex];
    final Future<List<SystemEntity>> entityListFuture = repository.findAllSystemsWithView(view);
    return SystemMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}