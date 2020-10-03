import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list.dart';


class TagListBloc extends ItemListBloc<Tag> {

  TagListBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<Tag>> getReadAllStream() {

    return iCollectionRepository.getAllTags();

  }

  @override
  Future<Tag> createFuture(AddItem event) {

    return iCollectionRepository.insertTag(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Tag> event) {

    return iCollectionRepository.deleteTag(event.item.ID);

  }

  @override
  Stream<List<Tag>> getReadViewStream(UpdateView event) {

    TagView tagView = TagView.values[event.viewIndex];

    return iCollectionRepository.getTagsWithView(tagView);

  }

}