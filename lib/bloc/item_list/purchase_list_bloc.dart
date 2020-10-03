import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list.dart';


class PurchaseListBloc extends ItemListBloc<Purchase> {

  PurchaseListBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<Purchase>> getReadAllStream() {

    return iCollectionRepository.getAllPurchases();

  }

  @override
  Future<Purchase> createFuture(AddItem event) {

    return iCollectionRepository.insertPurchase(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Purchase> event) {

    return iCollectionRepository.deletePurchase(event.item.ID);

  }

  @override
  Stream<List<Purchase>> getReadViewStream(UpdateView event) {

    PurchaseView purchaseView = PurchaseView.values[event.viewIndex];

    return iCollectionRepository.getPurchasesWithView(purchaseView);

  }

}