import 'package:backend/model/model.dart' show DLC, DLCView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, DLCRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class DLCListBloc extends ItemListBloc<DLC, DLCRepository> {
  DLCListBloc({
    required GameCollectionRepository collectionRepository,
    required DLCListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.dlcRepository, managerBloc: managerBloc);

  @override
  Stream<List<DLC>> getReadViewStream(UpdateView event) {

    final DLCView dlcView = DLCView.values[event.viewIndex];

    return repository.findAllDLCsWithView(dlcView);

  }
}