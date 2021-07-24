import 'package:backend/entity/entity.dart' show PurchaseEntity, PurchaseID, PurchaseView;
import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import 'item_search.dart';


class PurchaseSearchBloc extends ItemRemoteSearchBloc<Purchase, PurchaseEntity, PurchaseID, PurchaseRepository> {
  PurchaseSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseRepository);

  @override
  Future<List<Purchase>> getInitialItems() {

    final Future<List<PurchaseEntity>> entityListFuture = repository.findAllPurchasesWithView(PurchaseView.LastCreated, super.maxSuggestions);
    return PurchaseMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<Purchase>> getSearchItems(String query) {

    final Future<List<PurchaseEntity>> entityListFuture = repository.findAllPurchasesByDescription(query, super.maxResults);
    return PurchaseMapper.futureEntityListToModelList(entityListFuture);

  }
}