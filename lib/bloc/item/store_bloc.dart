import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/store.dart';

import 'item.dart';


class StoreBloc extends ItemBloc {

  StoreBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Store> createFuture() {

    return collectionRepository.insertStore('');

  }

  @override
  Future<dynamic> deleteFuture(CollectionItem item) {

    return collectionRepository.deleteStore(item.ID);

  }

}