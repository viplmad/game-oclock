import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/tag.dart';

import 'item.dart';


class TagBloc extends ItemBloc {

  TagBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Tag> createFuture() {

    return collectionRepository.insertTag('');

  }

  @override
  Future<dynamic> deleteFuture(CollectionItem item) {

    return collectionRepository.deleteTag(item.ID);

  }

}