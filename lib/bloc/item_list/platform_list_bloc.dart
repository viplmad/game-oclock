import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class PlatformListBloc extends ItemListBloc<Platform> {

  PlatformListBloc({
    @required PlatformBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Platform>> getReadAllStream() {

    return collectionRepository.getAllPlatforms();

  }

  @override
  Stream<List<Platform>> getReadViewStream(UpdateView event) {

    int viewIndex = platformViews.indexOf(event.view);
    PlatformView platformView = PlatformView.values[viewIndex];

    return collectionRepository.getPlatformsWithView(platformView);

  }

}