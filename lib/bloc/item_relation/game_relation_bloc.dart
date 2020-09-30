import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class GameRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Game, W> {

  GameRelationBloc({
    @required int gameID,
    @required GameBloc itemBloc,
  }) : super(itemID: gameID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case DLC:
        return collectionRepository.getDLCsFromGame(itemID) as Stream<List<W>>;
      case Purchase:
        return collectionRepository.getPurchasesFromGame(itemID) as Stream<List<W>>;
      case Platform:
        return collectionRepository.getPlatformsFromGame(itemID) as Stream<List<W>>;
      case Tag:
        return collectionRepository.getTagsFromGame(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}