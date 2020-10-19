import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class TagRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Tag, W> {
  TagRelationBloc({
    @required int itemId,
    @required ICollectionRepository iCollectionRepository,
    @required TagRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.getGamesFromTag(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}