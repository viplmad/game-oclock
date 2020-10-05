import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_list_manager/item_list_manager.dart';
import 'item_list.dart';


class TagListBloc extends ItemListBloc<Tag> {

  TagListBloc({
    @required ICollectionRepository iCollectionRepository,
    @required TagListManagerBloc managerBloc,
  }) : super(iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<List<Tag>> getReadAllStream() {

    return iCollectionRepository.getAllTags();

  }

  @override
  Stream<List<Tag>> getReadViewStream(UpdateView event) {

    TagView tagView = TagView.values[event.viewIndex];

    return iCollectionRepository.getTagsWithView(tagView);

  }

}