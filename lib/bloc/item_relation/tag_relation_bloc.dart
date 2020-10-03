import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_relation.dart';


class TagRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Tag, W> {

  TagRelationBloc({
    @required int tagID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: tagID, collectionRepository: collectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return collectionRepository.getGamesFromTag(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGameTag(otherID, itemID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGameTag(otherID, itemID);
    }

    return super.deleteRelationFuture(event);

  }

}