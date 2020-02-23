import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class TypeRelationBloc extends ItemRelationBloc {

  TypeRelationBloc({
    @required int typeID,
    @required Type relationType,
    @required ItemBloc itemBloc,
  }) : super(itemID: typeID, relationType: relationType, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationType) {
      case Purchase:
        return collectionRepository.getPurchasesFromType(itemID);
    }

    return super.getRelationStream();

  }

}