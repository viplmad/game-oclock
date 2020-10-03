import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class TypeDetailBloc extends ItemDetailBloc<PurchaseType> {

  TypeDetailBloc({
    @required int typeID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: typeID, collectionRepository: collectionRepository);

  @override
  Stream<PurchaseType> getReadStream() {

    return collectionRepository.getTypeWithID(itemID);

  }

  @override
  Future<PurchaseType> updateFuture(UpdateItemField<PurchaseType> event) {

    return collectionRepository.updateType(itemID, event.field, event.value);

  }

}