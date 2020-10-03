import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_list.dart';


class PlatformListBloc extends ItemListBloc<Platform> {

  PlatformListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<Platform>> getReadAllStream() {

    return collectionRepository.getAllPlatforms();

  }

  @override
  Future<Platform> createFuture(AddItem event) {

    return collectionRepository.insertPlatform(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Platform> event) {

    return collectionRepository.deletePlatform(event.item.ID);

  }

  @override
  Stream<List<Platform>> getReadViewStream(UpdateView event) {

    PlatformView platformView = PlatformView.values[event.viewIndex];

    return collectionRepository.getPlatformsWithView(platformView);

  }

}