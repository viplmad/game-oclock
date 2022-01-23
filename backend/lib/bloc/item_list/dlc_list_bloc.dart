import 'package:backend/entity/entity.dart' show DLCEntity, DLCID, DLCView;
import 'package:backend/model/model.dart' show DLC;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class DLCListBloc extends ItemListBloc<DLC, DLCEntity, DLCID, DLCRepository> {
  DLCListBloc({
    required GameCollectionRepository collectionRepository,
    required DLCListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.dlcRepository, managerBloc: managerBloc);

  @override
  Future<List<DLC>> getReadAllStream() {

    final Future<List<DLCEntity>> entityListFuture = repository.findAllWithView(DLCView.main);
    return DLCMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<DLC>> getReadViewStream(UpdateView event) {

    final DLCView view = DLCView.values[event.viewIndex];
    final Future<List<DLCEntity>> entityListFuture = repository.findAllWithView(view);
    return DLCMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}