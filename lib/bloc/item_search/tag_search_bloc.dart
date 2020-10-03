import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


class TagSearchBloc extends ItemSearchBloc<Tag> {

  TagSearchBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<Tag> createFuture(AddItem event) {

    return iCollectionRepository.insertTag(event.title ?? '');

  }

  @override
  Future<List<Tag>> getInitialItems() {

    return iCollectionRepository.getTagsWithView(TagView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<Tag>> getSearchItems(String query) {

    return iCollectionRepository.getTagsWithName(query, super.maxResults).first;

  }

}