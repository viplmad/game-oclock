import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class GameRelationBloc extends ItemRelationBloc {

  GameRelationBloc({
    @required int gameID,
    @required Type relationType,
    @required ItemBloc itemBloc,
  }) : super(itemID: gameID, relationType: relationType, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationType) {
      case DLC:
        return collectionRepository.getDLCsFromGame(itemID);
      case Purchase:
        return collectionRepository.getPurchasesFromGame(itemID);
      case Platform:
        return collectionRepository.getPlatformsFromGame(itemID);
      case Tag:
        return collectionRepository.getTagsFromGame(itemID);
    }

    return super.getRelationStream();

  }

}