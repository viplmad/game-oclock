import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class PlatformRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Platform, W> {

  PlatformRelationBloc({
    @required int platformID,
    @required PlatformBloc itemBloc,
  }) : super(itemID: platformID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return collectionRepository.getGamesFromPlatform(itemID) as Stream<List<W>>;
      case System:
        return collectionRepository.getSystemsFromPlatform(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}