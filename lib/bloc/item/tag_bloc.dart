import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class TagBloc extends ItemBloc<Tag> {

  TagBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Tag> createFuture(AddItem event) {

    return collectionRepository.insertTag(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Tag> event) {

    return collectionRepository.deleteTag(event.item.ID);

  }

  @override
  Future<Tag> updateFuture(UpdateItemField<Tag> event) {

    return collectionRepository.updateTag(event.item.ID, event.field, event.value);

  }

}