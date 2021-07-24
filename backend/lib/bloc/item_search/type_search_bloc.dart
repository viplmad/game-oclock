import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeID, TypeView;
import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import 'item_search.dart';


class TypeSearchBloc extends ItemRemoteSearchBloc<PurchaseType, PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeRepository> {
  TypeSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseTypeRepository);

  @override
  Future<List<PurchaseType>> getInitialItems() {

    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findAllPurchaseTypesWithView(TypeView.LastCreated, super.maxSuggestions);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<PurchaseType>> getSearchItems(String query) {

    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findAllPurchaseTypesByName(query, super.maxResults);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }
}