import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class SystemRelationBloc extends ItemRelationBloc {

  SystemRelationBloc({
    @required int systemID,
    @required String relationField,
    @required ItemBloc itemBloc,
  }) : super(itemID: systemID, relationField: relationField, itemBloc: itemBloc);

  @override
  Stream<List<CollectionItem>> getRelationStream() {

    switch(relationField) {
      case platformTable:
        return collectionRepository.getPlatformsFromSystem(itemID);
    }

  }

}