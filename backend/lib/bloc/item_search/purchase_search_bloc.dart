import 'package:backend/entity/entity.dart'
    show PurchaseEntity, PurchaseID, PurchaseView;
import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, PurchaseRepository;

import 'item_search.dart';

class PurchaseSearchBloc extends ItemRemoteSearchBloc<Purchase, PurchaseEntity,
    PurchaseID, PurchaseRepository> {
  PurchaseSearchBloc({
    required GameCollectionRepository collectionRepository,
    required int? viewIndex,
    this.viewYear,
  }) : super(
          repository: collectionRepository.purchaseRepository,
          viewIndex: viewIndex,
        );

  final int? viewYear;

  @override
  Future<List<Purchase>> getInitialItems() {
    final PurchaseView view = viewIndex != null
        ? PurchaseView.values[viewIndex!]
        : PurchaseView.lastCreated;
    final Future<List<PurchaseEntity>> entityListFuture =
        repository.findFirstWithView(view, super.maxSuggestions, viewYear);
    return PurchaseMapper.futureEntityListToModelList(entityListFuture);
  }

  @override
  Future<List<Purchase>> getSearchItems(String query) {
    if (viewIndex != null) {
      final PurchaseView view = PurchaseView.values[viewIndex!];
      final Future<List<PurchaseEntity>> entityListFuture =
          repository.findFirstWithViewByDescription(
        view,
        query,
        super.maxResults,
        viewYear,
      );
      return PurchaseMapper.futureEntityListToModelList(entityListFuture);
    } else {
      final Future<List<PurchaseEntity>> entityListFuture =
          repository.findFirstByDescription(query, super.maxResults);
      return PurchaseMapper.futureEntityListToModelList(entityListFuture);
    }
  }
}
