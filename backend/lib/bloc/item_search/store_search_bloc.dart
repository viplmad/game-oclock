import 'package:backend/model/model.dart' show Store, StoreView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, StoreRepository;

import 'item_search.dart';


class StoreSearchBloc extends ItemRemoteSearchBloc<Store, StoreRepository> {
  StoreSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.storeRepository);

  @override
  Future<List<Store>> getInitialItems() {

    return repository.findAllStoresWithView(StoreView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Store>> getSearchItems(String query) {

    return repository.findAllStoresByName(query, super.maxResults).first;

  }
}