import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class TagBloc extends ItemBloc<Tag> {

  TagBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Tag> createFuture(AddItem event) {

    return collectionRepository.insertTag(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Tag> event) {

    return collectionRepository.deleteTag(event.item.ID);

  }

  @override
  Future<Tag> updateFuture(UpdateItemField<Tag> event) {

    return collectionRepository.updateTag(event.item.ID, event.field, event.value);

  }

  @override
  Future<dynamic> addRelationFuture<W extends CollectionItem>(AddItemRelation<Tag, W> event) {

    int tagID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.insertGameTag(otherID, tagID);
    }

    return super.addRelationFuture<W>(event);

  }

  @override
  Future<dynamic> deleteRelationFuture<W extends CollectionItem>(DeleteItemRelation<Tag, W> event) {

    int tagID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Game:
        return collectionRepository.deleteGameTag(otherID, tagID);
    }

    return super.deleteRelationFuture<W>(event);

  }

}