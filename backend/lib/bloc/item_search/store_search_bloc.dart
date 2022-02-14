import 'package:backend/entity/entity.dart'
    show StoreEntity, StoreID, StoreView;
import 'package:backend/model/model.dart' show Store;
import 'package:backend/mapper/mapper.dart' show StoreMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, StoreRepository;

import 'item_search.dart';

class StoreSearchBloc
    extends ItemRemoteSearchBloc<Store, StoreEntity, StoreID, StoreRepository> {
  StoreSearchBloc({
    required GameCollectionRepository collectionRepository,
    required int? viewIndex,
  }) : super(
          repository: collectionRepository.storeRepository,
          viewIndex: viewIndex,
        );

  @override
  Future<List<Store>> getInitialItems() {
    final StoreView view = viewIndex != null
        ? StoreView.values[viewIndex!]
        : StoreView.lastCreated;
    final Future<List<StoreEntity>> entityListFuture =
        repository.findFirstWithView(view, super.maxSuggestions);
    return StoreMapper.futureEntityListToModelList(
      entityListFuture,
      repository.getImageURI,
    );
  }

  @override
  Future<List<Store>> getSearchItems(String query) {
    if (viewIndex != null) {
      final StoreView view = StoreView.values[viewIndex!];
      final Future<List<StoreEntity>> entityListFuture =
          repository.findFirstWithViewByName(view, query, super.maxResults);
      return StoreMapper.futureEntityListToModelList(
        entityListFuture,
        repository.getImageURI,
      );
    } else {
      final Future<List<StoreEntity>> entityListFuture =
          repository.findFirstByName(query, super.maxResults);
      return StoreMapper.futureEntityListToModelList(
        entityListFuture,
        repository.getImageURI,
      );
    }
  }
}
