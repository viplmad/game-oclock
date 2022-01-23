import 'package:backend/entity/entity.dart' show StoreEntity, StoreID, StoreView;
import 'package:backend/model/model.dart' show Store;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import 'item_search.dart';


class StoreSearchBloc extends ItemRemoteSearchBloc<Store, StoreEntity, StoreID, StoreRepository> {
  StoreSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.storeRepository);

  @override
  Future<List<Store>> getInitialItems() {

    final Future<List<StoreEntity>> entityListFuture = repository.findAllWithView(StoreView.lastCreated, super.maxSuggestions);
    return StoreMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }

  @override
  Future<List<Store>> getSearchItems(String query) {

    final Future<List<StoreEntity>> entityListFuture = repository.findAllByName(query, super.maxResults);
    return StoreMapper.futureEntityListToModelList(entityListFuture, repository.getImageURI);

  }
}