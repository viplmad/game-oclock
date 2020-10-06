import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


abstract class ItemSearchBloc<T extends CollectionItem> extends Bloc<ItemSearchEvent, ItemSearchState> {

  ItemSearchBloc({@required this.iCollectionRepository}) : super(ItemSearchEmpty<T>());

  final int maxResults = 10;
  final int maxSuggestions = 6;

  final ICollectionRepository iCollectionRepository;

  @override
  Stream<ItemSearchState> mapEventToState(ItemSearchEvent event) async* {

    yield* checkConnection();

    if(event is SearchTextChanged) {

      yield* _mapTextChangedToState(event);

    }

  }

  Stream<ItemSearchState> checkConnection() async* {

    if(iCollectionRepository.isClosed()) {
      yield ItemSearchError("Connection lost. Trying to reconnect");

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

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

  @override
  Future<void> close() {

    return super.close();

  }

  external Future<List<T>> getInitialItems();
  external Future<List<T>> getSearchItems(String query);

}