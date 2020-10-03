import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_relation.dart';


class SystemRelationBloc<W extends CollectionItem> extends ItemRelationBloc<System, W> {

  SystemRelationBloc({
    @required int systemID,
    @required ICollectionRepository collectionRepository,
  }) : super(itemID: systemID, collectionRepository: collectionRepository);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Platform:
        return collectionRepository.getPlatformsFromSystem(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Platform:
        return collectionRepository.insertPlatformSystem(otherID, itemID);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherID = event.otherItem.ID;

    switch(W) {
      case Platform:
        return collectionRepository.deletePlatformSystem(otherID, itemID);
    }

    return super.deleteRelationFuture(event);

  }

}