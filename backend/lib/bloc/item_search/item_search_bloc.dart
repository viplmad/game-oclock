import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:backend/model/model.dart' show Item;

import 'item_search.dart';


abstract class ItemSearchBloc<T extends Item> extends Bloc<ItemSearchEvent, ItemSearchState> {
  ItemSearchBloc() : super(ItemSearchEmpty<T>());

  final int maxResults = 10;
  final int maxSuggestions = 6;

  @override
  Stream<ItemSearchState> mapEventToState(ItemSearchEvent event) async* {

    if(event is SearchTextChanged) {

      yield* _mapTextChangedToState(event);

    }

  }

  Stream<ItemSearchState> _mapTextChangedToState(SearchTextChanged event) async* {

    yield ItemSearchLoading();

    try {

      final String query = event.query;
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

  Future<List<T>> getInitialItems();
  Future<List<T>> getSearchItems(String query);
}