import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/icollection_repository.dart';

import 'item_search.dart';


class TagSearchBloc extends ItemSearchBloc<Tag> {
  TagSearchBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<Tag>> getInitialItems() {

    return iCollectionRepository!.findAllGameTagsWithView(TagView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<Tag>> getSearchItems(String query) {

    return iCollectionRepository!.findAllGameTagsByName(query, super.maxResults).first;

  }
}