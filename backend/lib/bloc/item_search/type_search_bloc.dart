import 'package:backend/model/model.dart' show PurchaseType, TypeView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import 'item_search.dart';


class TypeSearchBloc extends ItemRemoteSearchBloc<PurchaseType, PurchaseTypeRepository> {
  TypeSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseTypeRepository);

  @override
  Future<List<PurchaseType>> getInitialItems() {

    return repository.findAllPurchaseTypesWithView(TypeView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<PurchaseType>> getSearchItems(String query) {

    return repository.findAllPurchaseTypesByName(query, super.maxResults).first;

  }
}