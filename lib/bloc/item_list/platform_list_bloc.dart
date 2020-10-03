import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list.dart';


class PlatformListBloc extends ItemListBloc<Platform> {

  PlatformListBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<Platform>> getReadAllStream() {

    return iCollectionRepository.getAllPlatforms();

  }

  @override
  Future<Platform> createFuture(AddItem event) {

    return iCollectionRepository.insertPlatform(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Platform> event) {

    return iCollectionRepository.deletePlatform(event.item.ID);

  }

  @override
  Stream<List<Platform>> getReadViewStream(UpdateView event) {

    PlatformView platformView = PlatformView.values[event.viewIndex];

    return iCollectionRepository.getPlatformsWithView(platformView);

  }

}