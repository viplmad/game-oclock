import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_detail.dart';


class TypeDetailBloc extends ItemDetailBloc<PurchaseType> {

  TypeDetailBloc({
    @required int itemID,
    @required ICollectionRepository iCollectionRepository,
  }) : super(itemID: itemID, iCollectionRepository: iCollectionRepository);

  @override
  Stream<PurchaseType> getReadStream() {

    return iCollectionRepository.getTypeWithID(itemID);

  }

  @override
  Future<PurchaseType> updateFuture(UpdateItemField<PurchaseType> event) {

    return iCollectionRepository.updateType(itemID, event.field, event.value);

  }

}