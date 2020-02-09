import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class PlatformRelationBloc extends ItemRelationBloc {

  PlatformRelationBloc({
    @required int platformID,
    @required String relationField,
    @required ItemBloc itemBloc,
  }) : super(itemID: platformID, relationField: relationField, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationField) {
      case gameTable:
        return collectionRepository.getGamesFromPlatform(itemID);
      case systemTable:
        return collectionRepository.getSystemsFromPlatform(itemID);
    }

  }

}