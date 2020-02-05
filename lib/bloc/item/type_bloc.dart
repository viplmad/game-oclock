import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/type.dart';

import 'item.dart';


class TypeBloc extends ItemBloc {

  TypeBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<PurchaseType> createFuture() {

    return collectionRepository.insertType('');

  }

  @override
  Future<dynamic> deleteFuture(CollectionItem item) {

    return collectionRepository.deleteType(item.ID);

  }

}