import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/dlc.dart';

import 'item.dart';


class DLCBloc extends ItemBloc {

  DLCBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<DLC> createFuture() {

    return collectionRepository.insertDLC('');

  }

  @override
  Future<dynamic> deleteFuture(CollectionItem item) {

    return collectionRepository.deleteDLC(item.ID);

  }

}