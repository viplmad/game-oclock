import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class PurchaseBloc extends ItemBloc<Purchase> {

  PurchaseBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Purchase> createFuture(AddItem event) {

    return collectionRepository.insertPurchase(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Purchase> event) {

    return collectionRepository.deletePurchase(event.item.ID);

  }

  @override
  Future<Purchase> updateFuture(UpdateItemField<Purchase> event) {
    
    return collectionRepository.updatePurchase(event.item.ID, event.field, event.value);
    
  }

}