import 'package:backend/model/model.dart' show System, SystemView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, SystemRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class SystemListBloc extends ItemListBloc<System, SystemRepository> {
  SystemListBloc({
    required GameCollectionRepository collectionRepository,
    required SystemListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.systemRepository, managerBloc: managerBloc);

  @override
  Stream<List<System>> getReadViewStream(UpdateView event) {

    final SystemView systemView = SystemView.values[event.viewIndex];

    return repository.findAllSystemsWithView(systemView);

  }
}