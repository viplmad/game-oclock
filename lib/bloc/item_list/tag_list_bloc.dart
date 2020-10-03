import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_list.dart';


class TagListBloc extends ItemListBloc<Tag> {

  TagListBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Stream<List<Tag>> getReadAllStream() {

    return collectionRepository.getAllTags();

  }

  @override
  Future<Tag> createFuture(AddItem event) {

    return collectionRepository.insertTag(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Tag> event) {

    return collectionRepository.deleteTag(event.item.ID);

  }

  @override
  Stream<List<Tag>> getReadViewStream(UpdateView event) {

    TagView tagView = TagView.values[event.viewIndex];

    return collectionRepository.getTagsWithView(tagView);

  }

}