import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class TagRelationBloc<W extends CollectionItem> extends ItemRelationBloc<Tag, W> {

  TagRelationBloc({
    @required int tagID,
    @required TagBloc itemBloc,
  }) : super(itemID: tagID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return collectionRepository.getGamesFromTag(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<Tag, W> event) {

    int tagID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGameTag(otherID, tagID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<Tag, W> event) {

    int tagID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGameTag(otherID, tagID);
    }

    return super.deleteRelationFuture(event);

  }

}