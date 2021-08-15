import 'package:backend/entity/entity.dart' show StoreEntity, StoreID, StoreView;
import 'package:backend/model/model.dart' show Store;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class StoreListBloc extends ItemListBloc<Store, StoreEntity, StoreID, StoreRepository> {
  StoreListBloc({
    required GameCollectionRepository collectionRepository,
    required StoreListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.storeRepository, managerBloc: managerBloc);

  @override
  Future<List<Store>> getReadAllStream() {

    final Future<List<StoreEntity>> entityListFuture = repository.findAllWithView(StoreView.Main);
    return StoreMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Store>> getReadViewStream(UpdateView event) {

    final StoreView view = StoreView.values[event.viewIndex];
    final Future<List<StoreEntity>> entityListFuture = repository.findAllWithView(view);
    return StoreMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}