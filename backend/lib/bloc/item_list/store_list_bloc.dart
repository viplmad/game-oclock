import 'package:backend/entity/entity.dart'
    show StoreEntity, StoreID, StoreView;
import 'package:backend/model/model.dart' show Store;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, StoreRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';

class StoreListBloc
    extends ItemListBloc<Store, StoreEntity, StoreID, StoreRepository> {
  StoreListBloc({
    required GameCollectionRepository collectionRepository,
    required StoreListManagerBloc managerBloc,
  }) : super(
          repository: collectionRepository.storeRepository,
          managerBloc: managerBloc,
        );

  @override
  Future<ViewParameters> getStartViewIndex() {
    return Future<ViewParameters>.value(
      ViewParameters(StoreView.main.index),
    );
  }

  @override
  Future<List<Store>> getAllWithView(int viewIndex, [int? page]) {
    final StoreView view = StoreView.values[viewIndex];
    final Future<List<StoreEntity>> entityListFuture =
        repository.findAllWithView(view, page);
    return StoreMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }
}
