import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class SystemRelationBloc extends ItemRelationBloc {

  SystemRelationBloc({
    @required int systemID,
    @required Type relationType,
    @required ItemBloc itemBloc,
  }) : super(itemID: systemID, relationType: relationType, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationType) {
      case Platform:
        return collectionRepository.getPlatformsFromSystem(itemID);
    }

    return super.getRelationStream();

  }

}