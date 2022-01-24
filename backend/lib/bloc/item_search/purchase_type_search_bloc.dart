import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeView;
import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import 'item_search.dart';


class PurchaseTypeSearchBloc extends ItemRemoteSearchBloc<PurchaseType, PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeRepository> {
  PurchaseTypeSearchBloc({
    required GameCollectionRepository collectionRepository,
  }) : super(repository: collectionRepository.purchaseTypeRepository);

  @override
  Future<List<PurchaseType>> getInitialItems() {

    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findFirstWithView(PurchaseTypeView.lastCreated, super.maxSuggestions);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<PurchaseType>> getSearchItems(String query) {

    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findFirstByName(query, super.maxResults);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }
}