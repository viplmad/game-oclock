import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_list.dart';


class PurchaseListBloc extends ItemListBloc<Purchase> {

  PurchaseListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<Purchase>> getReadAllStream() {

    return collectionRepository.getAllPurchases();

  }

  @override
  Future<Purchase> createFuture(AddItem event) {

    return collectionRepository.insertPurchase(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Purchase> event) {

    return collectionRepository.deletePurchase(event.item.ID);

  }

  @override
  Stream<List<Purchase>> getReadViewStream(UpdateView event) {

    PurchaseView purchaseView = PurchaseView.values[event.viewIndex];

    return collectionRepository.getPurchasesWithView(purchaseView);

  }

}