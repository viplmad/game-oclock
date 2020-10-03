import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';

class TagSearchBloc extends ItemSearchBloc<Tag> {

  TagSearchBloc({
    @required ICollectionRepository collectionRepository
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Tag> createFuture(AddItem event) {

    return collectionRepository.insertTag(event.title ?? '');

  }

  @override
  Future<List<Tag>> getInitialItems() {

    return collectionRepository.getTagsWithView(TagView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<Tag>> getSearchItems(String query) {

    return collectionRepository.getTagsWithName(query, super.maxResults).first;

  }

}