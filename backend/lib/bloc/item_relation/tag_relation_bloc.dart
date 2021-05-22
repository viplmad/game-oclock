import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import '../item_relation_manager/item_relation_manager.dart';
import 'item_relation.dart';


class TagRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Tag, W> {
  TagRelationBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required TagRelationManagerBloc<W> managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return iCollectionRepository.findAllGamesFromGameTag(itemId) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }
}