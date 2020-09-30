import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class TypeBloc extends ItemBloc<PurchaseType> {

  TypeBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<PurchaseType> createFuture(AddItem event) {

    return collectionRepository.insertType(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<PurchaseType> event) {

    return collectionRepository.deleteType(event.item.ID);

  }

  @override
  Future<PurchaseType> updateFuture(UpdateItemField<PurchaseType> event) {

    return collectionRepository.updateType(event.item.ID, event.field, event.value);

  }

  @override
  Future<dynamic> addRelationFuture<W extends CollectionItem>(AddItemRelation<PurchaseType, W> event) {

    int typeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.insertPurchaseType(otherID, typeID);
    }

    return super.addRelationFuture<W>(event);

  }

  @override
  Future<dynamic> deleteRelationFuture<W extends CollectionItem>(DeleteItemRelation<PurchaseType, W> event) {

    int typeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.deletePurchaseType(otherID, typeID);
    }

    return super.deleteRelationFuture<W>(event);

  }

}