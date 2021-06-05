import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class PurchaseListBloc extends ItemListBloc<Purchase> {
  PurchaseListBloc({
    required CollectionRepository iCollectionRepository,
    required PurchaseListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Purchase>> getReadAllStream() {

    return iCollectionRepository.findAllPurchases();

  }

  @override
  Stream<List<Purchase>> getReadViewStream(UpdateView event) {

    final PurchaseView purchaseView = PurchaseView.values[event.viewIndex];

    return iCollectionRepository.findAllPurchasesWithView(purchaseView);

  }

  @override
  Stream<List<Purchase>> getReadYearViewStream(UpdateYearView event) {

    final PurchaseView purchaseView = PurchaseView.values[event.viewIndex];

    return iCollectionRepository.findAllPurchasesWithYearView(purchaseView, event.year);

  }
}