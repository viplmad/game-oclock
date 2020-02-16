import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class TypeRelationBloc extends ItemRelationBloc {

  TypeRelationBloc({
    @required int typeID,
    @required String relationField,
    @required ItemBloc itemBloc,
  }) : super(itemID: typeID, relationField: relationField, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationField) {
      case purchaseTable:
        return collectionRepository.getPurchasesFromType(itemID);
    }

    return super.getRelationStream();

  }

}