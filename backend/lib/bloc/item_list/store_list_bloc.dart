import 'package:backend/model/model.dart' show Store, StoreView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class StoreListBloc extends ItemListBloc<Store, StoreRepository> {
  StoreListBloc({
    required GameCollectionRepository collectionRepository,
    required StoreListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.storeRepository, managerBloc: managerBloc);

  @override
  Stream<List<Store>> getReadViewStream(UpdateView event) {

    final StoreView storeView = StoreView.values[event.viewIndex];

    return repository.findAllStoresWithView(storeView);

  }
}