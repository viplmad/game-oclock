import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class PlatformListBloc extends ItemListBloc<Platform> {
  PlatformListBloc({
    required CollectionRepository iCollectionRepository,
    required PlatformListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Platform>> getReadAllStream() {

    return iCollectionRepository.findAllPlatforms();

  }

  @override
  Stream<List<Platform>> getReadViewStream(UpdateView event) {

    final PlatformView platformView = PlatformView.values[event.viewIndex];

    return iCollectionRepository.findAllPlatformsWithView(platformView);

  }
}