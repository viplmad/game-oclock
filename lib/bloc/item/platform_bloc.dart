import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/platform.dart';

import 'item.dart';


class PlatformBloc extends ItemBloc {

  PlatformBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Platform> createFuture() {

    return collectionRepository.insertPlatform('');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deletePlatform(event.item.ID);

  }

}