import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class SystemRelationBloc<W extends CollectionItem> extends ItemRelationBloc<System, W> {

  SystemRelationBloc({
    @required int systemID,
    @required SystemBloc itemBloc,
  }) : super(itemID: systemID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Platform:
        return collectionRepository.getPlatformsFromSystem(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}