import 'package:backend/entity/entity.dart' show PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeView;
import 'package:backend/model/model.dart' show PurchaseType;
import 'package:backend/mapper/mapper.dart' show PurchaseTypeMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseTypeRepository;

import 'item_search.dart';


class PurchaseTypeSearchBloc extends ItemRemoteSearchBloc<PurchaseType, PurchaseTypeEntity, PurchaseTypeID, PurchaseTypeRepository> {
  PurchaseTypeSearchBloc({
    required GameCollectionRepository collectionRepository,
    required int? viewIndex,
  }) : super(repository: collectionRepository.purchaseTypeRepository, viewIndex: viewIndex);

  @override
  Future<List<PurchaseType>> getInitialItems() {

    final PurchaseTypeView view = viewIndex != null? PurchaseTypeView.values[viewIndex!] : PurchaseTypeView.lastCreated;
    final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findFirstWithView(view, super.maxSuggestions);
    return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<PurchaseType>> getSearchItems(String query) {

    if(viewIndex != null) {
      final PurchaseTypeView view = PurchaseTypeView.values[viewIndex!];
      final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findFirstWithViewByName(view, query, super.maxResults);
      return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);
    } else {
      final Future<List<PurchaseTypeEntity>> entityListFuture = repository.findFirstByName(query, super.maxResults);
      return PurchaseTypeMapper.futureEntityListToModelList(entityListFuture);
    }

  }
}