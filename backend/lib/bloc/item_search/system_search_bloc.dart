import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_search.dart';


class SystemSearchBloc extends ItemSearchBloc<System> {
  SystemSearchBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<System>> getInitialItems() {

    return iCollectionRepository!.findAllSystemsWithView(SystemView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<System>> getSearchItems(String query) {

    return iCollectionRepository!.findAllSystemsByName(query, super.maxResults).first;

  }
}