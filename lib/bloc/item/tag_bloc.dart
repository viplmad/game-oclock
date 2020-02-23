import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'item.dart';


class TagBloc extends ItemBloc {

  TagBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Tag> createFuture(AddItem event) {

    return collectionRepository.insertTag(event.item != null? event.item.getTitle() : '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deleteTag(event.item.ID);

  }

  @override
  Future<Tag> updateFuture(UpdateItemField event) {

    return collectionRepository.updateTag(event.item.ID, event.field, event.value);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int tagID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case gameTable:
        return collectionRepository.insertGameTag(otherID, tagID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int tagID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case gameTable:
        return collectionRepository.deleteGameTag(otherID, tagID);
    }

    return super.deleteRelationFuture(event);

  }

}