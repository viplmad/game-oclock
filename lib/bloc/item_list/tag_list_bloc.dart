import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class TagListBloc extends ItemListBloc {

  TagListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Tag>> getReadAllStream() {

    return collectionRepository.getAllTags();

  }

  @override
  Stream<List<Tag>> getReadViewStream(UpdateView event) {

    int viewIndex = tagViews.indexOf(event.view);
    TagView tagView = TagView.values[viewIndex];

    return collectionRepository.getTagsWithView(tagView);

  }

}