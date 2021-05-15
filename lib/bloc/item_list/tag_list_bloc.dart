import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class TagListBloc extends ItemListBloc<Tag> {
  TagListBloc({
    required ICollectionRepository iCollectionRepository,
    required TagListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Tag>> getReadAllStream() {

    return iCollectionRepository.findAllGameTags();

  }

  @override
  Stream<List<Tag>> getReadViewStream(UpdateView event) {

    final TagView tagView = TagView.values[event.viewIndex];

    return iCollectionRepository.findAllGameTagsWithView(tagView);

  }
}