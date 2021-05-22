import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

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