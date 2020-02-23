import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class DLCRelationBloc extends ItemRelationBloc {

  DLCRelationBloc({
    @required int dlcID,
    @required Type relationType,
    @required ItemBloc itemBloc,
  }) : super(itemID: dlcID, relationType: relationType, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationType) {
      case Game:
        return collectionRepository.getBaseGameFromDLC(itemID).map( (CollectionItem game) => game != null? [game] : [] );
      case Purchase:
        return collectionRepository.getPurchasesFromDLC(itemID);
    }

    return super.getRelationStream();

  }

}