import 'package:backend/entity/entity.dart'
    show PurchaseEntity, PurchaseID, PurchaseView;
import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, PurchaseRepository;

import 'item_list.dart';

class PurchaseListBloc extends ItemListBloc<Purchase, PurchaseEntity,
    PurchaseID, PurchaseRepository> {
  PurchaseListBloc({
    required GameCollectionRepository collectionRepository,
    required super.managerBloc,
  }) : super(repository: collectionRepository.purchaseRepository);

  @override
  Future<ViewParameters> getStartViewIndex() {
    return Future<ViewParameters>.value(
      ViewParameters(PurchaseView.main.index),
    );
  }

  @override
  Future<List<Purchase>> getAllWithView(int viewIndex, [int? page]) {
    final PurchaseView view = PurchaseView.values[viewIndex];
    final Future<List<PurchaseEntity>> entityListFuture =
        repository.findAllWithView(view, page);
    return PurchaseMapper.futureEntityListToModelList(entityListFuture);
  }

  @override
  Future<List<Purchase>> getAllWithYearView(
    int viewIndex,
    int year, [
    int? page,
  ]) {
    final PurchaseView view = PurchaseView.values[viewIndex];
    final Future<List<PurchaseEntity>> entityListFuture =
        repository.findAllWithYearView(view, year, page);
    return PurchaseMapper.futureEntityListToModelList(entityListFuture);
  }
}
