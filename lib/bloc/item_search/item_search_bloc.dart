import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';


abstract class ItemSearchBloc extends Bloc<ItemSearchEvent, ItemSearchState> {

  ItemSearchBloc({@required this.itemType});

  final Type itemType;

  final int maxResults = 10;
  final int maxSuggestions = 6;

  @override
  ItemSearchState get initialState => ItemSearchEmpty();

  @override
  Stream<ItemSearchState> mapEventToState(ItemSearchEvent event) async* {

    yield* checkConnection();

    if(event is SearchTextChanged) {

      yield* _mapTextChangedToState(event);

    }

  }

  Stream<ItemSearchState> checkConnection() async* {

  }

  Stream<ItemSearchState> _mapTextChangedToState(SearchTextChanged event) async* {

    yield ItemSearchLoading();

    try {

      final query = event.query;
      if(query.isEmpty) {

        final List<CollectionItem> initialItems = await getInitialItems();
        yield ItemSearchEmpty(initialItems);

      } else {

        final List<CollectionItem> items = await getSearchItems(query);
        yield ItemSearchSuccess(items);

      }

    } catch(e) {

      yield ItemSearchError(e.toString());

    }

  }

  @override
  Future<void> close() {

    return super.close();

  }

  external Future<List<CollectionItem>> getInitialItems();
  external Future<List<CollectionItem>> getSearchItems(String query);

}