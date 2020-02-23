import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item_search.dart';


class ItemOnlineSearchBloc extends Bloc<ItemSearchEvent, ItemSearchState> {

  ItemOnlineSearchBloc({@required this.collectionRepository, @required this.itemType});

  final ICollectionRepository collectionRepository;
  final Type itemType;

  final int _maxResults = 10;
  final int _maxSuggestions = 6;

  @override
  ItemSearchState get initialState => ItemSearchEmpty();

  @override
  Stream<ItemSearchState> mapEventToState(ItemSearchEvent event) async* {

    if(event is SearchTextChanged) {

      yield* _mapTextChangedToState(event);

    }

  }

  Stream<ItemSearchState> _mapTextChangedToState(SearchTextChanged event) async* {

    yield ItemSearchLoading();

    try {

      final query = event.query;
      if(query.isEmpty) {

        final List<CollectionItem> items = await collectionRepository.getItemsWithView(itemType, 1, _maxSuggestions).first;
        yield ItemSearchEmpty(items);

      } else {

        final List<CollectionItem> items = await collectionRepository.getSearchItem(itemType, query, _maxResults).first;
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

}