import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';


abstract class ItemSearchBloc<T extends CollectionItem> extends Bloc<ItemSearchEvent, ItemSearchState> {

  ItemSearchBloc({@required this.collectionRepository});

  final int maxResults = 10;
  final int maxSuggestions = 6;

  final ICollectionRepository collectionRepository;

  @override
  ItemSearchState get initialState => ItemSearchEmpty<T>();

  @override
  Stream<ItemSearchState> mapEventToState(ItemSearchEvent event) async* {

    yield* checkConnection();

    if(event is SearchTextChanged) {

      yield* _mapTextChangedToState(event);

    } else if(event is AddItem) {

      yield* _mapAddItemToState(event);

    }

  }

  Stream<ItemSearchState> checkConnection() async* {

    if(collectionRepository.isClosed()) {
      yield ItemSearchError("Connection lost. Trying to reconnect");

      try {

        collectionRepository.reconnect();
        await collectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<ItemSearchState> _mapTextChangedToState(SearchTextChanged event) async* {

    yield ItemSearchLoading();

    try {

      final query = event.query;
      if(query.isEmpty) {

        final List<T> initialItems = await getInitialItems();
        yield ItemSearchEmpty<T>(initialItems);

      } else {

        final List<T> items = await getSearchItems(query);
        yield ItemSearchSuccess<T>(items);

      }

    } catch(e) {

      yield ItemSearchError(e.toString());

    }

  }

  Stream<ItemSearchState> _mapAddItemToState(AddItem event) async* {

    try {

      final T item = await createFuture(event);

      yield ItemAdded<T>(
        item,
      );

    } catch (e) {

      yield ItemNotAdded(e.toString());

    }

  }

  @override
  Future<void> close() {

    return super.close();

  }

  external Future<T> createFuture(AddItem event);
  external Future<List<T>> getInitialItems();
  external Future<List<T>> getSearchItems(String query);

}