import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class PurchaseListBloc extends ItemListBloc<Purchase> {
  PurchaseListBloc({
    required ICollectionRepository iCollectionRepository,
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