import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/dlc.dart';
import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';

class DLCRelationBloc extends ItemRelationBloc {

  DLCRelationBloc({
    @required int dlcID,
    @required String relationField,
    @required ItemBloc itemBloc,
  }) : super(itemID: dlcID, relationField: relationField, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationField) {
      case gameTable:
        return collectionRepository.getBaseGameFromDLC(itemID).map( (CollectionItem game) => [game] );
      case purchaseTable:
        return collectionRepository.getPurchasesFromDLC(itemID);
    }

  }

}