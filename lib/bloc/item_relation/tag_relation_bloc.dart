import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class TagRelationBloc extends ItemRelationBloc {

  TagRelationBloc({
    @required int tagID,
    @required Type relationType,
    @required ItemBloc itemBloc,
  }) : super(itemID: tagID, relationType: relationType, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationType) {
      case Game:
        return collectionRepository.getGamesFromTag(itemID);
    }

    return super.getRelationStream();

  }

}