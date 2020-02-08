import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/system.dart';

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

}