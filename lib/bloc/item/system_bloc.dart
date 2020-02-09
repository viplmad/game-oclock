import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'item.dart';


class SystemBloc extends ItemBloc {

  SystemBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<System> createFuture() {

    return collectionRepository.insertSystem('');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deleteSystem(event.item.ID);

  }

  @override
  Future<System> updateFuture(UpdateItemField event) {

    return collectionRepository.updateSystem(event.item.ID, event.field, event.value);

  }

  @override
  Future<dynamic> addRelationFuture(AddItemRelation event) {

    int systemID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case platformTable:
        return collectionRepository.insertPlatformSystem(otherID, systemID);
    }

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation event) {

    int systemID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(event.field) {
      case platformTable:
        return collectionRepository.deletePlatformSystem(otherID, systemID);
    }

  }

}