import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';

class TypeSearchBloc extends ItemSearchBloc<PurchaseType> {

  TypeSearchBloc({
    @required ICollectionRepository collectionRepository
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<PurchaseType> createFuture(AddItem event) {

    return collectionRepository.insertType(event.title ?? '');

  }

  @override
  Future<List<PurchaseType>> getInitialItems() {

    return collectionRepository.getTypesWithView(TypeView.Main, super.maxSuggestions).first;

  }

  @override
  Future<List<PurchaseType>> getSearchItems(String query) {

    return collectionRepository.getTypesWithName(query, super.maxResults).first;

  }

}