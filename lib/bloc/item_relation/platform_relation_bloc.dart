import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class PlatformRelationBloc extends ItemRelationBloc {

  PlatformRelationBloc({
    @required int platformID,
    @required Type relationType,
    @required ItemBloc itemBloc,
  }) : super(itemID: platformID, relationType: relationType, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationType) {
      case Game:
        return collectionRepository.getGamesFromPlatform(itemID);
      case System:
        return collectionRepository.getSystemsFromPlatform(itemID);
    }

    return super.getRelationStream();

  }

}