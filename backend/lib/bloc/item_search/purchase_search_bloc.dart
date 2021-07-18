import 'package:backend/model/model.dart' show Purchase, PurchaseView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import 'item_search.dart';


class PurchaseSearchBloc extends ItemRemoteSearchBloc<Purchase, PurchaseRepository> {
  PurchaseSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseRepository);

  @override
  Future<List<Purchase>> getInitialItems() {

    return repository.findAllPurchasesWithView(PurchaseView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Purchase>> getSearchItems(String query) {

    return repository.findAllPurchasesByDescription(query, super.maxResults).first;

  }
}