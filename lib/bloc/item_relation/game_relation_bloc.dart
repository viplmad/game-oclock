import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/game.dart';
import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';

class GameRelationBloc extends ItemRelationBloc {

  GameRelationBloc({
    @required int gameID,
    @required String relationField,
    @required ItemBloc itemBloc,
  }) : super(itemID: gameID, relationField: relationField, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationField) {
      case dlcTable:
        return collectionRepository.getDLCsFromGame(itemID);
      case purchaseTable:
        return collectionRepository.getPurchasesFromGame(itemID);
      case platformTable:
        return collectionRepository.getPlatformsFromGame(itemID);
      case tagTable:
        return collectionRepository.getTagsFromGame(itemID);
    }

  }

}