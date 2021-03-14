import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class PlatformListBloc extends ItemListBloc<Platform> {
  PlatformListBloc({
    required ICollectionRepository iCollectionRepository,
    required PlatformListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Platform>> getReadAllStream() {

    return iCollectionRepository.getAllPlatforms();

  }

  @override
  Stream<List<Platform>> getReadViewStream(UpdateView event) {

    PlatformView platformView = PlatformView.values[event.viewIndex];

    return iCollectionRepository.getPlatformsWithView(platformView);

  }
}