import 'package:backend/model/model.dart' show Purchase, PurchaseView;
import 'package:backend/repository/repository.dart' show GameCollectionRepository, PurchaseRepository;

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class PurchaseListBloc extends ItemListBloc<Purchase, PurchaseRepository> {
  PurchaseListBloc({
    required GameCollectionRepository collectionRepository,
    required PurchaseListManagerBloc managerBloc,
  }) : super(repository: collectionRepository.purchaseRepository, managerBloc: managerBloc);

  @override
  Stream<List<Purchase>> getReadViewStream(UpdateView event) {

    final PurchaseView purchaseView = PurchaseView.values[event.viewIndex];

    return repository.findAllPurchasesWithView(purchaseView);

  }

  @override
  Stream<List<Purchase>> getReadYearViewStream(UpdateYearView event) {

    final PurchaseView purchaseView = PurchaseView.values[event.viewIndex];

    return repository.findAllPurchasesWithYearView(purchaseView, event.year);

  }
}