import 'package:backend/entity/entity.dart' show PurchaseEntity, PurchaseID, PurchaseView;
import 'package:backend/model/model.dart' show Purchase;
import 'package:backend/mapper/mapper.dart' show PurchaseMapper;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class PurchaseListBloc extends ItemListBloc<Purchase, PurchaseEntity, PurchaseID, PurchaseRepository> {
  PurchaseListBloc({
    required GameCollectionRepository collectionRepository,
    required PurchaseListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.purchaseRepository, managerBloc: managerBloc);

  @override
  Future<List<Purchase>> getReadAllStream() {

    final Future<List<PurchaseEntity>> entityListFuture = repository.findAllWithView(PurchaseView.Main);
    return PurchaseMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<Purchase>> getReadViewStream(UpdateView event) {

    final PurchaseView view = PurchaseView.values[event.viewIndex];
    final Future<List<PurchaseEntity>> entityListFuture = repository.findAllWithView(view);
    return PurchaseMapper.futureEntityListToModelList(entityListFuture);

  }

  @override
  Future<List<Purchase>> getReadYearViewStream(UpdateYearView event) {

    final PurchaseView view = PurchaseView.values[event.viewIndex];
    final Future<List<PurchaseEntity>> entityListFuture = repository.findAllWithYearView(view, event.year);
    return PurchaseMapper.futureEntityListToModelList(entityListFuture);

  }
}