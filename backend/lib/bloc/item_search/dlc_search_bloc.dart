import 'dart:async';

import 'package:backend/model/model.dart';

import 'package:backend/repository/collection_repository.dart';

import 'item_search.dart';


class DLCSearchBloc extends ItemSearchBloc<DLC> {
  DLCSearchBloc({
    required CollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<DLC>> getInitialItems() {

    return iCollectionRepository!.findAllDLCsWithView(DLCView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<DLC>> getSearchItems(String query) {

    return iCollectionRepository!.findAllDLCsByName(query, super.maxResults).first;

  }
}