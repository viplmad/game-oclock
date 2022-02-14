import 'package:backend/entity/entity.dart' show DLCEntity, DLCID, DLCView;
import 'package:backend/model/model.dart' show DLC;
import 'package:backend/mapper/mapper.dart' show DLCMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, DLCRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';

class DLCListBloc extends ItemListBloc<DLC, DLCEntity, DLCID, DLCRepository> {
  DLCListBloc({
    required GameCollectionRepository collectionRepository,
    required DLCListManagerBloc managerBloc,
  }) : super(
          repository: collectionRepository.dlcRepository,
          managerBloc: managerBloc,
        );

  @override
  Future<List<DLC>> getReadAllStream([int? page]) {
    final Future<List<DLCEntity>> entityListFuture =
        repository.findAllWithView(DLCView.main, page);
    return DLCMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }

  @override
  Future<List<DLC>> getReadViewStream(int viewIndex, [int? page]) {
    final DLCView view = DLCView.values[viewIndex];
    final Future<List<DLCEntity>> entityListFuture =
        repository.findAllWithView(view, page);
    return DLCMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }
}
